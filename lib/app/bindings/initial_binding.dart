import 'package:get/get.dart';
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
    // 1. Gamification first (others depend on it)
    Get.lazyPut<GamificationController>(
      () => GamificationController(), fenix: true);
    
    // 2. Notification (needed by routine)
    Get.lazyPut<NotificationController>(
      () => NotificationController(), fenix: true);
      
    // 3. Core controllers
    Get.lazyPut<RoutineController>(
      () => RoutineController(), fenix: true);
    Get.lazyPut<GardenController>(
      () => GardenController(), fenix: true);
    
    // 4. Weather (depends on nothing critical at startup)
    Get.lazyPut<WeatherController>(
      () => WeatherController(), fenix: true);
      
    // 5. Home (depends on routine)
    Get.lazyPut<HomeController>(
      () => HomeController(), fenix: true);
      
    // 6. Rest
    Get.lazyPut<LibraryController>(
      () => LibraryController(), fenix: true);
    Get.lazyPut<AiController>(
      () => AiController(), fenix: true);
    Get.lazyPut<ProfileController>(
      () => ProfileController(), fenix: true);
    Get.lazyPut<BackupController>(
      () => BackupController(), fenix: true);
    Get.lazyPut<CompostController>(
      () => CompostController(), fenix: true);
  }
}
