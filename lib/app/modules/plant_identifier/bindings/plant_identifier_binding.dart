import 'package:get/get.dart';
import '../controllers/plant_identifier_controller.dart';

class PlantIdentifierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantIdentifierController>(() => PlantIdentifierController());
  }
}
