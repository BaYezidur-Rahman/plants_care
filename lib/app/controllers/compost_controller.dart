import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/models/compost_model.dart';
import '../utils/hive_boxes.dart';
import 'notification_controller.dart';
import 'gamification_controller.dart';

class CompostController extends GetxController {
  late Box<CompostModel> _compostBox;
  final _notifController = Get.find<NotificationController>();
  
  final batches = <CompostModel>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _compostBox = Hive.box<CompostModel>(HiveBoxes.compost);
  }

  @override
  void onReady() {
    super.onReady();
    _loadBatches();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _loadBatches() {
    batches.assignAll(_compostBox.values.toList());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      batches.refresh(); // Triggers UI update for countdowns
      _checkMaturity();
    });
  }

  Future<void> addBatch(String type, int daysToMature) async {
    final now = DateTime.now();
    final batch = CompostModel(
      id: 'compost_${now.millisecondsSinceEpoch}',
      name: type,
      startDate: now,
      estimatedDays: daysToMature,
      ingredients: [], // Placeholder
      isReady: false,
    );
    await _compostBox.put(batch.id, batch);
    _loadBatches();
    
    // Schedule notification for the future
    _notifController.scheduleCompostReady(batch);
  }

  void _checkMaturity() async {
    final now = DateTime.now();
    for (var i = 0; i < batches.length; i++) {
      final b = batches[i];
      if (!b.isReady && now.isAfter(b.expectedReadyDate)) {
        final updated = b.copyWith(isReady: true, readyDate: now);
        await _compostBox.put(b.id, updated);
        batches[i] = updated;
        
        // Notification is already scheduled, but we can show an extra one if needed
        // Or handle the transition here
        
        Get.find<GamificationController>().onCompostCompleted();
      }
    }
  }

  double getProgress(CompostModel batch) {
    final total = batch.expectedReadyDate.difference(batch.startDate).inSeconds;
    final elapsed = DateTime.now().difference(batch.startDate).inSeconds;
    if (total <= 0) return 1.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  int getDaysRemaining(CompostModel batch) {
    final diff = batch.expectedReadyDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }
}
