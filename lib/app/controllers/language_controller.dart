import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../utils/hive_boxes.dart';
import '../utils/bangla_numbers.dart';

class LanguageController extends GetxController {
  final _box = Hive.box(HiveBoxes.settings);
  final _langKey = 'locale';

  RxString locale = 'bn'.obs; // Default Bangla

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void _loadLanguage() {
    locale.value = _box.get(_langKey, defaultValue: 'bn');
    Get.updateLocale(Locale(locale.value));
  }

  void setLanguage(String code) async {
    locale.value = code;
    Get.updateLocale(Locale(code));
    await _box.put(_langKey, code);
  }

  bool get isBangla => locale.value == 'bn';

  String formatNumber(int n) {
    if (isBangla) {
      return BanglaNumbers.toBangla(n.toString());
    }
    return n.toString();
  }
}
