import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plantcare_pro/app/utils/app_transitions.dart';

import 'app/bindings/initial_binding.dart';
import 'app/controllers/language_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/data/models/badge_model.dart';
import 'app/data/models/care_log_model.dart';
import 'app/data/models/chat_message_model.dart';
import 'app/data/models/compost_model.dart';
import 'app/data/models/journal_entry_model.dart';
import 'app/data/models/plant_model.dart';
import 'app/data/models/task_model.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/utils/hive_boxes.dart';
import 'app/utils/app_translations.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Timezones early
  tz.initializeTimeZones();

  // Initialize Hive
  await Hive.initFlutter();

  // Register ALL Type Adapters
  Hive.registerAdapter(PlantModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(CareLogModelAdapter());
  Hive.registerAdapter(JournalEntryModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  Hive.registerAdapter(CompostModelAdapter());
  Hive.registerAdapter(BadgeModelAdapter());

  // Open essential boxes for startup
  await Hive.openBox(HiveBoxes.settings);

  // Initialize Essential Controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(LanguageController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Obx(
      () => GetMaterialApp(
        title: 'গাছের যত্ন',
        debugShowCheckedModeBanner: false,

        // Localization
        translations: AppTranslations(),

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,

        // Localization
        locale: Locale(languageController.locale.value),
        fallbackLocale: const Locale('en'),
        supportedLocales: const [
          Locale('en'),
          Locale('bn'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // Routing
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
        initialBinding: InitialBinding(),

        // Transitions
        defaultTransition: Transition.fade,
        customTransition: CustomFadeScaleTransition(),
        transitionDuration: const Duration(milliseconds: 400),

        // Error Handling
        builder: (context, child) {
          ErrorWidget.builder = (details) => const Scaffold(
                body: Center(
                    child: Text('কিছু একটা ভুল হয়েছে!',
                        style: TextStyle(color: Colors.red))),
              );
          return child!;
        },
      ),
    );
  }
}
