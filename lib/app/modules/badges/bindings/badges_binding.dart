import 'package:get/get.dart';
import '../../../controllers/gamification_controller.dart';

class BadgesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamificationController>(() => GamificationController());
  }
}
