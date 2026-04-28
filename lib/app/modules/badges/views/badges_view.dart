// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../controllers/gamification_controller.dart';
import '../../../widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class BadgesView extends GetView<GamificationController> {
  const BadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সাফল্য ও ব্যাজ 🏆')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStreakHeader(context)),
          Obx(() => SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildBadgeItem(context, controller.badges[index]),
                childCount: controller.badges.length,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStreakHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _streakStat('🔥 বর্তমান স্ট্রিক', '${controller.currentStreak.value} দিন'),
              Container(width: 1, height: 40, color: Colors.white24),
              _streakStat('⭐ সেরা স্ট্রিক', '${controller.longestStreak.value} দিন'),
              Container(width: 1, height: 40, color: Colors.white24),
              _streakStat('💎 পয়েন্ট', '${controller.totalPoints.value}'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _streakStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildBadgeItem(BuildContext context, dynamic badge) {
    final isEarned = badge.isEarned;
    final progress = badge.currentCount / badge.requiredCount;

    return GestureDetector(
      onTap: () => _showBadgeDetail(context, badge),
      child: Column(
        children: [
          Expanded(
            child: AppCard(
              padding: EdgeInsets.zero,
              color: isEarned ? Color(badge.iconColor).withOpacity(0.1) : Colors.grey[100],
              child: Center(
                child: Opacity(
                  opacity: isEarned ? 1.0 : 0.3,
                  child: Text(
                    badge.iconEmoji,
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.nameBn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isEarned ? FontWeight.bold : FontWeight.normal,
              color: isEarned ? AppColors.textPrimary : Colors.grey,
            ),
          ),
          if (!isEarned)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(badge.iconColor)),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale();
  }

  void _showBadgeDetail(BuildContext context, dynamic badge) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.iconEmoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(badge.nameBn, style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: 8),
            Text(badge.descriptionBn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (badge.isEarned)
              Text('অর্জিত হয়েছে: ${DateFormat('dd MMM yyyy').format(badge.earnedDate!)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold))
            else
              Text('অগ্রগতি: ${badge.currentCount}/${badge.requiredCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
