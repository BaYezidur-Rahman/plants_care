import 'package:get/get.dart';
import '../../../controllers/compost_controller.dart';

class CompostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompostController>(() => CompostController());
  }
}
