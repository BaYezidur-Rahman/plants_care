import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/models/plant_model.dart';
import '../data/repositories/plant_repository.dart';
import '../utils/hive_boxes.dart';
import 'gamification_controller.dart';

class GardenController extends GetxController {
  final PlantRepository _repository = PlantRepository();
  late Box<PlantModel> _plantBox;
  
  final plants = <PlantModel>[].obs;
  final isLoading = false.obs;

  // Filter & Search
  final filterCategory = ''.obs;
  final sortBy = 'urgent'.obs; // urgent, name, health, date
  final searchQuery = ''.obs;
  final isGridView = true.obs;

  @override
  void onInit() {
    super.onInit();
    _plantBox = Hive.box<PlantModel>(HiveBoxes.plants);
    _repository.init().then((_) => loadPlants());
  }

  void loadPlants() {
    plants.assignAll(_plantBox.values.toList());
  }

  List<PlantModel> get filteredPlants {
    var list = plants.toList();

    // 1. Filter by category
    if (filterCategory.value.isNotEmpty && filterCategory.value != 'সব') {
      list = list.where((p) => p.category == filterCategory.value).toList();
    }

    // 2. Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((p) => 
        p.name.toLowerCase().contains(q) || 
        p.nameBn.toLowerCase().contains(q) ||
        p.nickname.toLowerCase().contains(q) ||
        p.nicknameBn.toLowerCase().contains(q)
      ).toList();
    }

    // 3. Sort
    switch (sortBy.value) {
      case 'name':
        list.sort((a, b) => a.nameBn.compareTo(b.nameBn));
        break;
      case 'health':
        list.sort((a, b) => a.healthScore.compareTo(b.healthScore));
        break;
      case 'date':
        list.sort((a, b) => b.datePlanted.compareTo(a.datePlanted));
        break;
      case 'urgent':
      default:
        // Sort by health (lower health = more urgent)
        list.sort((a, b) => a.healthScore.compareTo(b.healthScore));
        break;
    }

    return list;
  }

  Map<String, int> get stats {
    final total = plants.length;
    final needCare = plants.where((p) => p.healthScore < 60).length;
    final healthy = plants.where((p) => p.healthScore >= 80).length;
    return {'total': total, 'needCare': needCare, 'healthy': healthy};
  }

  Future<void> addPlant(PlantModel plant) async {
    await _repository.addPlant(plant);
    loadPlants();
    Get.find<GamificationController>().onPlantAdded();
  }

  Future<void> updatePlant(PlantModel plant) async {
    await _repository.updatePlant(plant);
    loadPlants();
  }

  Future<void> deletePlant(String id) async {
    await _repository.deletePlant(id);
    loadPlants();
  }

  String calculateAge(DateTime datePlanted) {
    final now = DateTime.now();
    final difference = now.difference(datePlanted);
    final days = difference.inDays;

    if (days < 30) {
      return "$days দিন";
    } else if (days < 365) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      return remainingDays > 0 ? "$months মাস $remainingDays দিন" : "$months মাস";
    } else {
      final years = (days / 365).floor();
      final months = ((days % 365) / 30).floor();
      return months > 0 ? "$years বছর $months মাস" : "$years বছর";
    }
  }

  String getUrgencyLabel(PlantModel plant) {
    if (plant.healthScore < 40) return "⚠️ আজই পানি দিন";
    if (plant.healthScore < 70) return "💧 যত্নের প্রয়োজন";
    return "✅ ঠিক আছে";
  }
}
