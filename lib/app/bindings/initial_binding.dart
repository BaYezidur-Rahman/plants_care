import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/garden_controller.dart';
import '../controllers/routine_controller.dart';
import '../controllers/library_controller.dart';
import '../controllers/ai_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/backup_controller.dart';
import '../controllers/weather_controller.dart';
import '../controllers/compost_controller.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/notification_controller.dart';
import '../modules/home/controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Data/Logic
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<GardenController>(() => GardenController(), fenix: true);
    Get.lazyPut<RoutineController>(() => RoutineController(), fenix: true);
    Get.lazyPut<LibraryController>(() => LibraryController(), fenix: true);
    Get.lazyPut<AiController>(() => AiController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<BackupController>(() => BackupController(), fenix: true);
    Get.lazyPut<WeatherController>(() => WeatherController(), fenix: true);
    Get.lazyPut<CompostController>(() => CompostController(), fenix: true);
    Get.lazyPut<GamificationController>(() => GamificationController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
  }
}
