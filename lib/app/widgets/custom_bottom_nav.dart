// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double itemWidth = MediaQuery.of(context).size.width / 5;

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Pill Indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            top: 0,
            left: currentIndex * itemWidth + (itemWidth / 2) - 15,
            child: Container(
              width: 30,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  0, 'হোম', IconsaxPlusLinear.home, IconsaxPlusBold.home),
              _buildNavItem(
                  1, 'বাগান', IconsaxPlusLinear.tree, IconsaxPlusBold.tree),
              _buildNavItem(2, 'রুটিন', IconsaxPlusLinear.calendar,
                  IconsaxPlusBold.calendar),
              _buildNavItem(
                  3, 'লাইব্রেরি', IconsaxPlusLinear.book, IconsaxPlusBold.book),
              _buildNavItem(4, 'প্রোফাইল', IconsaxPlusLinear.profile_circle,
                  IconsaxPlusBold.profile_circle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, String label, IconData outlineIcon, IconData filledIcon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
