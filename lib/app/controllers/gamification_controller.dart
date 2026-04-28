// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../utils/hive_boxes.dart';
import '../data/models/badge_model.dart';
import '../theme/app_colors.dart';

class GamificationController extends GetxController {
  late Box<BadgeModel> _badgeBox;
  late Box _settingsBox;

  final badges = <BadgeModel>[].obs;
  final currentStreak = 0.obs;
  final longestStreak = 0.obs;
  final totalPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _badgeBox = Hive.box<BadgeModel>(HiveBoxes.badges);
    _settingsBox = Hive.box(HiveBoxes.settings);
  }

  @override
  void onReady() {
    super.onReady();
    _loadData();
    initBadgesOnFirstRun();
  }

  void _loadData() {
    badges.assignAll(_badgeBox.values.toList());
    currentStreak.value = _settingsBox.get('currentStreak', defaultValue: 0);
    longestStreak.value = _settingsBox.get('longestStreak', defaultValue: 0);
    totalPoints.value = _settingsBox.get('totalPoints', defaultValue: 0);
  }

  Future<void> initBadgesOnFirstRun() async {
    if (_badgeBox.isEmpty) {
      final initialBadges = [
        // Planting Badges
        _b('seedling', 'Seedling Starter', 'নতুন বাগানি',
            'প্রথম গাছ যোগ করেছেন', 1, '🌱', Colors.green),
        _b('green_thumb', 'Green Thumb', 'সবুজ হাত', '৫টি গাছ যোগ করেছেন', 5,
            '🌿', Colors.teal),
        _b('variety_lover', 'Variety Lover', 'বৈচিত্র্য প্রেমী',
            '৩টি আলাদা ক্যাটাগরির গাছ', 3, '🌈', Colors.orange),

        // Task Badges
        _b('first_drop', 'First Drop', 'প্রথম বিন্দু',
            'প্রথম কাজ সম্পন্ন করেছেন', 1, '💧', Colors.blue),
        _b('century_club', 'Century Club', 'শতক ক্লাব',
            '১০০টি কাজ সম্পন্ন করেছেন', 100, '💯', Colors.purple),
        _b('early_bird', 'Early Bird', 'ভোরজাগা পাখি',
            'সকাল ৮টার আগে ৫টি কাজ করেছেন', 5, '🌅', Colors.amber),
        _b('streak_7', 'Week Warrior', 'সপ্তাহের যোদ্ধা',
            'টানা ৭ দিন কাজ করেছেন', 7, '🔥', Colors.deepOrange),

        // AI Badges
        _b('ai_enthusiast', 'AI Enthusiast', 'AI অনুরাগী',
            '১০ বার AI চ্যাট ব্যবহার করেছেন', 10, '🤖', Colors.indigo),
        _b('plant_doctor', 'Plant Doctor', 'উদ্ভিদ চিকিৎসক',
            '৫ বার গাছ শনাক্ত করেছেন', 5, '🔍', Colors.red),

        // Compost Badges
        _b('compost_king', 'Compost King', 'কম্পোস্ট রাজা',
            'প্রথম কম্পোস্ট তৈরি করেছেন', 1, '🔋', Colors.brown),

        // Additional Badges to reach 15
        _b('social_sharer', 'Social Sharer', 'সামাজিক বাগানি',
            'আপনার বাগান শেয়ার করেছেন', 1, '📢', Colors.lightBlue),
        _b('night_owl', 'Night Owl', 'রাতজাগা পাখি',
            'রাত ১০টার পর কাজ সম্পন্ন করেছেন', 5, '🦉', Colors.blueGrey),
        _b('weather_wise', 'Weather Wise', 'আবহাওয়া সচেতন',
            'বৃষ্টির সময় পানি দেয়া স্থগিত করেছেন', 1, '🌦️', Colors.cyan),
        _b('persistent_planter', 'Persistent Planter', 'একনিষ্ঠ রোপনকারী',
            'টানা ৩০ দিন গাছ চেক করেছেন', 30, '💪', Colors.redAccent),
        _b('master_gardener', 'Master Gardener', 'মাস্টার গার্ডেনার',
            'সব ব্যাজ অর্জন করেছেন', 15, '👑', Colors.yellow),
      ];
      for (var badge in initialBadges) {
        await _badgeBox.put(badge.id, badge);
      }
      _loadData();
    }
  }

  BadgeModel _b(String id, String name, String nameBn, String descBn, int req,
      String emoji, Color color) {
    return BadgeModel(
      id: id,
      name: name,
      nameBn: nameBn,
      description: name,
      descriptionBn: descBn,
      category: 'general',
      iconEmoji: emoji,
      iconColor: color.value,
      requiredCount: req,
    );
  }

  void onPlantAdded() {
    _updateProgress('seedling');
    _updateProgress('green_thumb');
    _checkVariety();
  }

  void onTaskComplete() {
    _updateProgress('first_drop');
    _updateProgress('century_club');

    final hour = DateTime.now().hour;
    if (hour < 8) _updateProgress('early_bird');

    _addPoints(10);
    updateStreak();
  }

  void onAIChatUsed() => _updateProgress('ai_enthusiast');
  void onPlantIdentified() => _updateProgress('plant_doctor');
  void onCompostCompleted() => _updateProgress('compost_king');

  Future<void> _updateProgress(String badgeId) async {
    final badge = _badgeBox.get(badgeId);
    if (badge != null && !badge.isEarned) {
      final newCount = badge.currentCount + 1;
      final updated = badge.copyWith(
        currentCount: newCount,
        isEarned: newCount >= badge.requiredCount,
        earnedDate: newCount >= badge.requiredCount ? DateTime.now() : null,
      );
      await _badgeBox.put(badgeId, updated);
      if (updated.isEarned) _showBadgeOverlay(updated);
      _loadData();
    }
  }

  void _checkVariety() {
    // Implement logic to check unique categories from plants box
  }

  void _addPoints(int p) {
    totalPoints.value += p;
    _settingsBox.put('totalPoints', totalPoints.value);
  }

  void updateStreak() {
    final lastTaskDate = _settingsBox.get('lastTaskDate');
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastTaskDate == null) {
      currentStreak.value = 1;
    } else {
      final last = DateTime.parse(lastTaskDate);
      final diff = DateTime.now().difference(last).inDays;

      if (diff == 1) {
        currentStreak.value++;
      } else if (diff > 1) {
        currentStreak.value = 1;
      }
    }

    if (currentStreak.value > longestStreak.value) {
      longestStreak.value = currentStreak.value;
      _settingsBox.put('longestStreak', longestStreak.value);
    }

    _settingsBox.put('currentStreak', currentStreak.value);
    _settingsBox.put('lastTaskDate', today);

    if (currentStreak.value >= 7) _updateProgress('streak_7');
  }

  void _showBadgeOverlay(BadgeModel badge) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(badge.iconEmoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              const Text('অভিনন্দন! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('আপনি "${badge.nameBn}" ব্যাজ অর্জন করেছেন',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text('ধন্যবাদ',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension BadgeExtension on BadgeModel {
  BadgeModel copyWith({int? currentCount, bool? isEarned, DateTime? earnedDate}) {
    return BadgeModel(
      id: id,
      name: name,
      nameBn: nameBn,
      description: description,
      descriptionBn: descriptionBn,
      category: category,
      iconEmoji: iconEmoji,
      iconColor: iconColor,
      requiredCount: requiredCount,
      currentCount: currentCount ?? this.currentCount,
      isEarned: isEarned ?? this.isEarned,
      earnedDate: earnedDate ?? this.earnedDate,
    );
  }
}
