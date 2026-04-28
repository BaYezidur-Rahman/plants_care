// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController {
  final encyclopedia = <dynamic>[].obs;
  final recipes = <dynamic>[].obs;
  final companions = <dynamic>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    try {
      final plantsJson = await rootBundle.loadString('assets/data/plants.json');
      encyclopedia.assignAll(json.decode(plantsJson));

      final recipesJson = await rootBundle.loadString('assets/data/organic_recipes.json');
      recipes.assignAll(json.decode(recipesJson));

      final companionsJson = await rootBundle.loadString('assets/data/companions.json');
      companions.assignAll(json.decode(companionsJson));
    } catch (e) {
      print('Error loading library data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
