import 'package:get/get.dart';
import '../../../controllers/ai_controller.dart';

class AiChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiController>(() => AiController());
  }
}
