import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../utils/hive_boxes.dart';

class ThemeController extends GetxController {
  final _box = Hive.box(HiveBoxes.settings);
  final _themeKey = 'themeMode';

  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _box.get(_themeKey, defaultValue: 'system');
    switch (savedTheme) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _box.put(_themeKey, mode.name);
  }

  void toggleTheme() {
    if (Get.isDarkMode) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  bool get isDark => themeMode.value == ThemeMode.dark || (themeMode.value == ThemeMode.system && Get.isPlatformDarkMode);
}
