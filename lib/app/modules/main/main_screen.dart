import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantcare_pro/app/modules/home/controllers/home_controller.dart';

import '../../widgets/ai_floating_button.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../community_gallery/community_gallery.dart';
import '../garden/garden_screen.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../routine/views/routine_view.dart';

class MainScreen extends GetView<HomeController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  const HomeScreen(),
                  Obx(() => controller.activatedTabs.contains(1)
                      ? const GardenScreen()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(2)
                      ? const CommunityGallery()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(3)
                      ? const RoutineView()
                      : const SizedBox.shrink()),
                  Obx(() => controller.activatedTabs.contains(4)
                      ? const LibraryScreen()
                      : const SizedBox.shrink()),
                ],
              )),

          // AI Floating Button - Updated Position
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 85,
            right: 16,
            child: const AiFloatingButton(),
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
