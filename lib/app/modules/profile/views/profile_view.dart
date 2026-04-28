import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/gamification_controller.dart';
import '../../../controllers/garden_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_card.dart';

class ProfileView extends GetView<GamificationController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final gardenController = Get.find<GardenController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsGrid(context, gardenController),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                  const SizedBox(height: 24),
                  _buildLegalSection(context),
                  const SizedBox(height: 40),
                  Text('ভার্সন ১.০.০', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(IconsaxPlusBold.user, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text('আমার প্রোফাইল', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Obx(() => Text('${controller.totalPoints.value} পয়েন্ট', style: const TextStyle(color: Colors.white70))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, GardenController gardenController) {
    return Obx(() {
      final stats = gardenController.stats;
      return Row(
        children: [
          _statCard('মোট গাছ', '${stats['total']}', IconsaxPlusBold.tree, AppColors.primary),
          const SizedBox(width: 12),
          _statCard('অর্জিত ব্যাজ', '${controller.badges.where((b) => b.isEarned).length}', IconsaxPlusBold.award, AppColors.warning),
          const SizedBox(width: 12),
          _statCard('স্ট্রিক', '${controller.currentStreak.value}', IconsaxPlusBold.flash_1, AppColors.error),
        ],
      );
    }).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('সেটিংস'),
        const SizedBox(height: 12),
        _menuItem(IconsaxPlusLinear.notification, 'নোটিফিকেশন', () {}),
        _menuItem(IconsaxPlusLinear.global, 'ভাষা পরিবর্তন', () => Get.toNamed(AppRoutes.settings)),
        _menuItem(IconsaxPlusLinear.cloud_change, 'ব্যাকআপ ও রিস্টোর', () => Get.toNamed(AppRoutes.backup)),
        _menuItem(IconsaxPlusLinear.moon, 'ডার্ক মোড', () {}),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildLegalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('অন্যান্য'),
        const SizedBox(height: 12),
        _menuItem(IconsaxPlusLinear.info_circle, 'আমাদের সম্পর্কে', () {}),
        _menuItem(IconsaxPlusLinear.shield_tick, 'প্রাইভেসি পলিসি', () {}),
        _menuItem(IconsaxPlusLinear.message_question, 'সহায়তা', () {}),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.grey[50],
      ),
    );
  }
}
