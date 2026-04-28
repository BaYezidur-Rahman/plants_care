// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/compost_controller.dart';
import '../../../widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class CompostView extends GetView<CompostController> {
  const CompostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('কম্পোস্ট ট্র্যাকার ♻️')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildCompostCard(context, controller.batches[index]),
                    childCount: controller.batches.length,
                  ),
                )),
          ),
          SliverToBoxAdapter(child: _buildGuide(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBatchSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(IconsaxPlusLinear.add, color: Colors.white),
        label: const Text('নতুন ব্যাচ', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05)),
      child: Column(
        children: [
          const Icon(IconsaxPlusBold.refresh,
              size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('জৈব সার তৈরি করুন', style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: 8),
          const Text('বাড়ির বর্জ্য থেকে তৈরি করুন পুষ্টিকর সার',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildCompostCard(BuildContext context, dynamic batch) {
    final progress = controller.getProgress(batch);
    final daysLeft = controller.getDaysRemaining(batch);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      batch.isReady ? AppColors.success : AppColors.primary),
                ),
              ),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(batch.name, style: AppTextStyles.titleMedium(context)),
                Text(
                    batch.isReady
                        ? 'ব্যবহারের জন্য প্রস্তুত! 🎉'
                        : '$daysLeft দিন বাকি',
                    style: TextStyle(
                        color:
                            batch.isReady ? AppColors.success : Colors.grey)),
              ],
            ),
          ),
          if (batch.isReady)
            const Icon(IconsaxPlusBold.verify, color: AppColors.success)
          else
            const Icon(IconsaxPlusLinear.timer_1, color: AppColors.primary),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildGuide(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('কম্পোস্ট গাইড 📖', style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: 16),
          _guideTile(
              'কি কি দিবেন? ✅',
              'শাকসবজির খোসা, ফলের অবশিষ্টাংশ, শুকনো পাতা, চা-পাতা।',
              Colors.green),
          _guideTile(
              'কি দিবেন না? ❌',
              'মাছ-মাংস, তেলযুক্ত খাবার, প্লাস্টিক, কাঁচ, ডেইরি পণ্য।',
              Colors.red),
          _guideTile('টিপস 💡', 'মাঝে মাঝে নাড়িয়ে দিন এবং আর্দ্রতা বজায় রাখুন।',
              Colors.amber),
        ],
      ),
    );
  }

  Widget _guideTile(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  void _showAddBatchSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('নতুন কম্পোস্ট ব্যাচ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _typeOption('রান্নাঘরের বর্জ্য (৩০ দিন)', 30),
            _typeOption('শুকনো পাতা ও বাগান (৪৫ দিন)', 45),
            _typeOption('মিক্সড কম্পোস্ট (৬০ দিন)', 60),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _typeOption(String label, int days) {
    return ListTile(
      leading: const Icon(IconsaxPlusLinear.refresh_circle),
      title: Text(label),
      onTap: () {
        controller.addBatch(label, days);
        Get.back();
      },
    );
  }
}
