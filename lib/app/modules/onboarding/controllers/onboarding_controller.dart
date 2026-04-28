import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/hive_boxes.dart';

class OnboardingController extends GetxController {
  final _box = Hive.box(HiveBoxes.settings);
  final pageController = PageController();
  
  final currentPage = 0.obs;
  
  // Setup Page Fields
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final selectedGardenerType = ''.obs;
  final selectedPlantTypes = <String>[].obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previous() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    pageController.jumpToPage(4);
  }

  final isFinishing = false.obs;

  Future<void> finishOnboarding() async {
    if (isFinishing.value) return;
    
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('ত্রুটি', 'আপনার নাম লিখুন');
      return;
    }

    isFinishing.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    
    try {
      // Save to Hive
      await _box.put('userName', nameController.text.trim());
      await _box.put('userCity', cityController.text.trim());
      await _box.put('gardenerType', selectedGardenerType.value);
      await _box.put('plantTypes', selectedPlantTypes.toList());
      await _box.put('onboardingDone', true);

      // Success Animation and Navigate
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      isFinishing.value = false;
      Get.snackbar('Error', 'তথ্য সংরক্ষণ করতে সমস্যা হয়েছে');
    }
  }
}
