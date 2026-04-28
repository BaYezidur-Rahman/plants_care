import 'package:hive/hive.dart';
import '../models/plant_model.dart';
import '../../utils/hive_boxes.dart';

class PlantRepository {
  late Box<PlantModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<PlantModel>(HiveBoxes.plants);
  }

  List<PlantModel> getAllPlants() {
    return _box.values.toList();
  }

  Future<void> addPlant(PlantModel plant) async {
    await _box.put(plant.id, plant);
  }

  Future<void> updatePlant(PlantModel plant) async {
    await plant.save();
  }

  Future<void> deletePlant(String id) async {
    await _box.delete(id);
  }

  PlantModel? getPlantById(String id) {
    return _box.get(id);
  }
}
