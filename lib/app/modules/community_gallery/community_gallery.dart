// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import '../../theme/app_colors.dart';
import '../../utils/hive_boxes.dart';

class CommunityGallery extends StatefulWidget {
  const CommunityGallery({super.key});

  @override
  State<CommunityGallery> createState() => _CommunityGalleryState();
}

class _CommunityGalleryState extends State<CommunityGallery> {
  final _emailController = TextEditingController();
  final _settingsBox = Hive.box(HiveBoxes.settings);

  void _saveEmail() {
    if (_emailController.text.contains('@')) {
      _settingsBox.put('notify_email', _emailController.text);
      Get.snackbar(
        'ধন্যবাদ!',
        'গ্যালারি চালু হলে আপনাকে ইমেইল করা হবে।',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
      _emailController.clear();
    } else {
      Get.snackbar('ত্রুটি', 'সঠিক ইমেইল এড্রেস দিন');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B3B2B), Color(0xFF0F1E16)],
        ),
      ),
      child: Stack(
        children: [
          // Floating Emojis
          ...List.generate(10, (index) => _buildFloatingEmoji(index)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 80))
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(duration: const Duration(seconds: 2), curve: Curves.easeInOut),
                  const SizedBox(height: 24),
                  const Text(
                    'Community Gallery',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'শীঘ্রই আসছে...',
                    style: TextStyle(color: Color(0xFF88DAB9), fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'আমাদের কমিউনিটি গ্যালারিতে আপনার বাগান শেয়ার করার ফিচারটি দ্রুত যোগ করা হচ্ছে। আপডেট পেতে আপনার ইমেইল দিয়ে রাখুন।',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'আপনার ইমেইল দিন',
                      hintStyle: const TextStyle(color: Colors.white30),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B3B2B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('জানান আমাকে', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingEmoji(int index) {
    final random = Random();
    final emojis = ['🍃', '🌿', '🌱', '🌸', '🌼', '🌷'];
    final emoji = emojis[random.nextInt(emojis.length)];
    final startX = random.nextDouble() * Get.width;
    final startY = random.nextDouble() * Get.height;
    final duration = Duration(seconds: random.nextInt(5) + 5);

    return Positioned(
      left: startX,
      top: startY,
      child: Text(emoji, style: const TextStyle(fontSize: 24))
          .animate(onPlay: (controller) => controller.repeat())
          .moveY(begin: 0, end: -200, duration: duration, curve: Curves.easeInOut)
          .fadeOut(duration: duration, curve: Curves.easeIn)
          .moveX(begin: 0, end: (random.nextBool() ? 100 : -100), duration: duration),
    );
  }
}
