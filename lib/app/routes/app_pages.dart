import 'package:get/get.dart';
import 'app_routes.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/main/views/main_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/garden/bindings/garden_binding.dart';
import '../modules/garden/garden_screen.dart';
import '../modules/garden/views/plant_detail_view.dart';
import '../modules/routine/bindings/routine_binding.dart';
import '../modules/routine/views/routine_view.dart';
import '../modules/library/bindings/library_binding.dart';
import '../modules/library/library_screen.dart';
import '../modules/ai_chat/bindings/ai_chat_binding.dart';
import '../modules/ai_chat/chat_view.dart';
import '../modules/plant_identifier/bindings/plant_identifier_binding.dart';
import '../modules/plant_identifier/views/plant_identifier_view.dart';
import '../modules/compost/bindings/compost_binding.dart';
import '../modules/compost/views/compost_view.dart';
import '../modules/badges/bindings/badges_binding.dart';
import '../modules/badges/views/badges_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/backup/bindings/backup_binding.dart';
import '../modules/backup/views/backup_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.garden,
      page: () => const GardenScreen(),
      binding: GardenBinding(),
    ),
    GetPage(
      name: AppRoutes.routine,
      page: () => const RoutineView(),
      binding: RoutineBinding(),
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => const LibraryScreen(),
      binding: LibraryBinding(),
    ),
    GetPage(
      name: AppRoutes.aiChat,
      page: () => const AiChatScreen(),
      binding: AiChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.plantIdentifier,
      page: () => const PlantIdentifierView(),
      binding: PlantIdentifierBinding(),
    ),
    GetPage(
      name: AppRoutes.compost,
      page: () => const CompostView(),
      binding: CompostBinding(),
    ),
    GetPage(
      name: AppRoutes.badges,
      page: () => const BadgesView(),
      binding: BadgesBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.backup,
      page: () => const BackupView(),
      binding: BackupBinding(),
    ),
    GetPage(
      name: AppRoutes.plantDetail,
      page: () => const PlantDetailView(),
      // Reusing GardenBinding for simplicity or create a separate one if needed
      binding: GardenBinding(),
    ),
  ];
}
