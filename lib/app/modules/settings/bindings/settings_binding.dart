import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override 
  void dependencies() {
    // Settings usually uses theme and language controllers which are already in InitialBinding
    // but we can put them here if needed for specific settings logic
  }
}
