import 'package:get/get.dart';
import '../../../controllers/garden_controller.dart';
import '../../../controllers/routine_controller.dart';
import '../../../controllers/library_controller.dart';
import '../../home/controllers/home_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GardenController>(() => GardenController());
    Get.lazyPut<RoutineController>(() => RoutineController());
    Get.lazyPut<LibraryController>(() => LibraryController());
  }
}
