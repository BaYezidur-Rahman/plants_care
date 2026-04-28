// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/onboarding_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              _buildPage1(context),
              _buildPage2(context),
              _buildPage3(context),
              _buildPage4(context),
              _buildPage5(context),
            ],
          ),
          
          // Skip Button
          Obx(() {
            if (controller.currentPage.value < 3) {
              return Positioned(
                top: 50,
                right: 20,
                child: TextButton(
                  onPressed: controller.skip,
                  child: const Text('Skip', style: TextStyle(color: Colors.white)),
                ),
              );
            }
            return const SizedBox();
          }),

          // Navigation Controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                Obx(() => controller.currentPage.value > 0
                    ? IconButton(
                        icon: const Icon(IconsaxPlusLinear.arrow_left),
                        onPressed: controller.previous,
                      )
                    : const SizedBox(width: 48)),

                // Progress Dots
                _buildProgressDots(),

                // Next Button
                Obx(() => controller.currentPage.value < 4
                    ? _buildNextButton()
                    : const SizedBox(width: 48)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Obx(() {
          final isSelected = controller.currentPage.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isSelected ? 24 : 8,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.textHint,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        });
      }),
    );
  }

  Widget _buildNextButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(IconsaxPlusLinear.arrow_right, color: Colors.white),
        onPressed: controller.next,
      ),
    );
  }

  Widget _buildPage1(BuildContext context) {
    return _pageWrapper(
      context: context,
      gradient: const LinearGradient(colors: [Color(0xFF1B2F1E), Color(0xFF2D6A4F)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.path_square, size: 200, color: Colors.white70),
          const SizedBox(height: 40),
          Text('গাছের যত্ন 🌿', style: AppTextStyles.displayLarge(context).copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text('আপনার বাগানের সেরা সঙ্গী', style: AppTextStyles.titleLarge(context).copyWith(color: Colors.white70)),
          const SizedBox(height: 20),
          Text('গাছ লাগান, যত্ন নিন, ভালোবাসুন', style: AppTextStyles.bodyLarge(context).copyWith(color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context) {
    return _pageWrapper(
      context: context,
      color: const Color(0xFFD8F3DC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.cpu_charge, size: 200, color: AppColors.primary),
          const SizedBox(height: 40),
          Text('AI Plant Doctor 🤖', style: AppTextStyles.displayLarge(context)),
          const SizedBox(height: 12),
          Text('গাছের ছবি দিলেই রোগ ধরে ফেলবে', style: AppTextStyles.titleLarge(context).copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          _featureRow('✅ রোগ ও পোকা শনাক্ত করুন'),
          _featureRow('✅ অচেনা গাছ চিনুন'),
          _featureRow('✅ বিশেষজ্ঞ পরামর্শ পান'),
        ],
      ),
    );
  }

  Widget _buildPage3(BuildContext context) {
    return _pageWrapper(
      context: context,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.calendar, size: 100, color: AppColors.primary),
          const SizedBox(height: 40),
          Text('স্মার্ট রুটিন 📅', style: AppTextStyles.displayLarge(context)),
          const SizedBox(height: 12),
          Text('AI নিজেই আপনার গাছের রুটিন তৈরি করবে', style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: 32),
          // Fake Task Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentWarm,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: const Row(
              children: [
                Icon(IconsaxPlusBold.drop, color: AppColors.water),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('বেলি গাছে পানি দিন', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('আজ সকাল ৮:০০ টা', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage4(BuildContext context) {
    return _pageWrapper(
      context: context,
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.cloud_cross, size: 100, color: AppColors.textSecondary),
          const SizedBox(height: 40),
          Text('সবসময় আপনার সাথে 🌾', style: AppTextStyles.displayLarge(context)),
          const SizedBox(height: 12),
          Text('ইন্টারনেট ছাড়াও ৫০+ গাছের তথ্য পাবেন', style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: 32),
          const Text('🍅 🌹 🌿 🍌 🌶️ 🥬', style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }

  Widget _buildPage5(BuildContext context) {
    return _pageWrapper(
      context: context,
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text('আপনাকে একটু জানি 🌱', style: AppTextStyles.displayLarge(context)),
            const SizedBox(height: 12),
            Text('আপনার জন্য অভিজ্ঞতা সাজিয়ে দেবো', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: 40),
            
            // Name Field
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(IconsaxPlusLinear.user),
                hintText: 'আপনার নাম',
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideX(begin: 0.1),
            
            const SizedBox(height: 20),
            
            // City Field
            TextField(
              controller: controller.cityController,
              decoration: const InputDecoration(
                prefixIcon: Icon(IconsaxPlusLinear.location),
                hintText: 'আপনার শহর',
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: 0.1),
            
            const SizedBox(height: 30),
            
            _sectionLabel(context, 'আপনি কেমন বাগানি?'),
            const SizedBox(height: 12),
            Obx(() => Wrap(
              spacing: 8,
              children: [
                _choiceChip('🌱 নতুন চাষি'),
                _choiceChip('🌿 শখের বাগানি'),
                _choiceChip('🌳 অভিজ্ঞ কৃষক'),
                _choiceChip('🏠 ছাদ বাগানি'),
              ],
            )).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideX(begin: 0.1),
            
            const SizedBox(height: 30),
            
            _sectionLabel(context, 'কোন ধরনের গাছ আছে?'),
            const SizedBox(height: 12),
            Obx(() => Wrap(
              spacing: 8,
              children: [
                _multiChoiceChip('🍎 ফলের গাছ'),
                _multiChoiceChip('🥬 সবজি'),
                _multiChoiceChip('🌸 ফুলের গাছ'),
                _multiChoiceChip('🌿 ভেষজ'),
              ],
            )).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideX(begin: 0.1),
            
            const SizedBox(height: 50),
            
            ElevatedButton(
              onPressed: controller.finishOnboarding,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text('শুরু করি! 🌿', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _pageWrapper({required BuildContext context, Color? color, Gradient? gradient, required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: color, gradient: gradient),
      child: SafeArea(child: child.animate().fadeIn(duration: const Duration(milliseconds: 400)).slideX(begin: 0.1)),
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _choiceChip(String label) {
    final isSelected = controller.selectedGardenerType.value == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => controller.selectedGardenerType.value = label,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
    );
  }

  Widget _multiChoiceChip(String label) {
    final isSelected = controller.selectedPlantTypes.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          controller.selectedPlantTypes.add(label);
        } else {
          controller.selectedPlantTypes.remove(label);
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
    );
  }
}
