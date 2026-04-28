import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../controllers/routine_controller.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/models/task_model.dart';
import '../../../utils/hive_boxes.dart';
import '../../../data/services/plant_advisor_service.dart';

class HomeController extends GetxController {
  late Box _settingsBox;
  late Box<PlantModel> _plantBox;

  final currentIndex = 0.obs;
  final userName = 'বাগানি'.obs;
  final greeting = 'সুপ্রভাত'.obs;
  final dailyTip = ''.obs;

  final todayTasks = <TaskModel>[].obs;
  final recentPlants = <PlantModel>[].obs;
  final activatedTabs = [0].obs;

  // New Services
  final advisor = PlantAdvisorService();

  @override
  void onInit() {
    super.onInit();

    // 1. Sync Load from Hive (Fast)
    _loadLocalData();

    // 2. Async Load for potentially heavier operations
    Future.delayed(Duration.zero, () async {
      await _loadRemoteData();
    });
  }

  void _loadLocalData() {
    try {
      _settingsBox = Hive.box(HiveBoxes.settings);
      _plantBox = Hive.box<PlantModel>(HiveBoxes.plants);

      userName.value = _settingsBox.get('userName', defaultValue: 'বাগানি');
      _updateGreeting();
      _loadDailyTip();
      _loadDashboardData();
    } catch (e) {
      print('❌ Home local data error: $e');
    }
  }

  Future<void> _loadRemoteData() async {
    // Placeholder for any remote API calls needed for home
    // Currently home data is mostly local Hive data
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'সুপ্রভাত';
    } else if (hour < 17) {
      greeting.value = 'শুভ অপরাহ্ন';
    } else {
      greeting.value = 'শুভ সন্ধ্যা';
    }
  }

  void _loadDailyTip() {
    final tips = [
      'গাছের পাতায় নিয়মিত জল স্প্রে করুন।',
      'মাটি শুকিয়ে গেলে তবেই জল দিন।',
      'সকালের নরম রোদ গাছের জন্য ভালো।',
      'জৈব সার ব্যবহার করার চেষ্টা করুন।',
    ];
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    dailyTip.value = tips[dayOfYear % tips.length];
  }

  void _loadDashboardData() {
    try {
      // Safe way to get tasks - check if controller exists first
      if (Get.isRegistered<RoutineController>()) {
        final routineCtrl = Get.find<RoutineController>();
        todayTasks.assignAll(routineCtrl.getTasksForDate(DateTime.now()));
      } else {
        // RoutineController not ready yet, load tasks directly from Hive
        final taskBox = Hive.box<TaskModel>(HiveBoxes.tasks);
        final today = DateTime.now();
        final todayList = taskBox.values.where((task) {
          return task.scheduledDate.year == today.year &&
              task.scheduledDate.month == today.month &&
              task.scheduledDate.day == today.day &&
              !task.isCompleted;
        }).toList();
        todayTasks.assignAll(todayList);
      }

      // Load recent plants safely
      if (Hive.isBoxOpen(HiveBoxes.plants)) {
        final allPlants = _plantBox.values.toList();
        allPlants.sort((a, b) => a.healthScore.compareTo(b.healthScore));
        recentPlants.assignAll(allPlants.take(5));
      }
    } catch (e) {
      print('⚠️ Dashboard load error (non-fatal): $e');
      todayTasks.clear();
      recentPlants.clear();
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
    if (!activatedTabs.contains(index)) {
      activatedTabs.add(index);
    }
  }

  void changePage(int index) {
    changeTabIndex(index);
  }

  Future<void> completeTask(String taskId) async {
    await Get.find<RoutineController>().completeTask(taskId);
    _loadDashboardData();
  }
}
