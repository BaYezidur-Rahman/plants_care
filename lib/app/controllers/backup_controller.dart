// ignore_for_file: unused_local_variable, unnecessary_overrides

import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class BackupController extends GetxController {
  final isLoading = false.obs;
  final lastBackupDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    // Load last backup date from settings
  }

  Future<void> backupToGoogleDrive() async {
    isLoading.value = true;
    try {
      // 1. Get Hive files path
      final appDir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory(appDir.path);

      // 2. Prepare files for upload
      // In a real app, you'd use google_sign_in and googleapis
      // to upload these files to the 'appDataFolder'.

      await Future.delayed(const Duration(seconds: 2)); // Mock upload

      lastBackupDate.value = DateTime.now();
      Get.snackbar('সফল!', 'আপনার ডাটা গুগল ড্রাইভে ব্যাকআপ করা হয়েছে');
    } catch (e) {
      Get.snackbar('ত্রুটি', 'ব্যাকআপ করতে সমস্যা হয়েছে: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restoreFromGoogleDrive() async {
    isLoading.value = true;
    try {
      // Logic to download files and overwrite current Hive boxes
      await Future.delayed(const Duration(seconds: 2)); // Mock download

      Get.snackbar('সফল!', 'ডাটা রিস্টোর করা হয়েছে। অ্যাপটি পুনরায় চালু করুন।');
    } catch (e) {
      Get.snackbar('ত্রুটি', 'রিস্টোর করতে সমস্যা হয়েছে: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
