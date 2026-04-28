import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/gemini_service.dart';
import '../../../utils/hive_boxes.dart';

enum IdentifierState { idle, loading, success, error, notPlant }

class PlantIdentifierController extends GetxController {
  final GeminiService _geminiService = GeminiService();
  final _historyBox = Hive.box(HiveBoxes.settings); // Reusing settings for simple history or create new

  final state = IdentifierState.idle.obs;
  final result = Rx<Map<String, dynamic>?>(null);
  final selectedImage = Rx<File?>(null);
  final history = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final list = _historyBox.get('id_history', defaultValue: []);
    history.assignAll(List<Map<String, dynamic>>.from(list));
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
      identify();
    }
  }

  Future<void> identify() async {
    if (selectedImage.value == null) return;

    state.value = IdentifierState.loading;
    try {
      final bytes = await selectedImage.value!.readAsBytes();
      final data = await _geminiService.identifyPlant(bytes);

      if (data['isPlant'] == false || (data['confidence'] ?? 0) < 30) {
        state.value = IdentifierState.notPlant;
      } else {
        result.value = data;
        state.value = IdentifierState.success;
        
        // Add to history
        _addToHistory(data);
      }
    } catch (e) {
      state.value = IdentifierState.error;
    }
  }

  void _addToHistory(Map<String, dynamic> data) {
    final newItem = {
      'name': data['plantNameBn'],
      'image': selectedImage.value?.path,
      'date': DateTime.now().toIso8601String(),
    };
    
    final currentList = List<Map<String, dynamic>>.from(history);
    currentList.insert(0, newItem);
    if (currentList.length > 10) currentList.removeLast();
    
    history.assignAll(currentList);
    _historyBox.put('id_history', currentList);
  }

  void reset() {
    state.value = IdentifierState.idle;
    selectedImage.value = null;
    result.value = null;
  }
}
