import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/ai_floating_button.dart';
import '../../../widgets/custom_bottom_nav.dart';
import '../../garden/garden_screen.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../library/library_screen.dart';
import '../../profile/views/profile_view.dart';
import '../../routine/views/routine_view.dart';

class MainView extends GetView<HomeController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  const HomeView(),
                  Obx(() => controller.activatedTabs.contains(1)
                      ? const GardenScreen()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(2)
                      ? const RoutineView()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(3)
                      ? const LibraryScreen()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(4)
                      ? const ProfileView()
                      : const SizedBox.shrink()),
                ],
              )),
          // AI Floating Button
          const Positioned(
            bottom: 100,
            right: 16,
            child: AiFloatingButton(),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => CustomBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
          )),
    );
  }
}
