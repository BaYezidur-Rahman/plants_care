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
    const Color selectedColor = Color(0xFF2D5A27);

    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Top Indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            top: 0,
            left: currentIndex * itemWidth + (itemWidth / 2) - 15,
            child: Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : selectedColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'হোম', IconsaxPlusLinear.home, IconsaxPlusBold.home, isDark, selectedColor),
                _buildNavItem(1, 'বাগান', IconsaxPlusLinear.tree, IconsaxPlusBold.tree, isDark, selectedColor),
                _buildNavItem(2, 'গ্যালারি', IconsaxPlusLinear.gallery, IconsaxPlusBold.gallery, isDark, selectedColor),
                _buildNavItem(3, 'রুটিন', IconsaxPlusLinear.calendar, IconsaxPlusBold.calendar, isDark, selectedColor),
                _buildNavItem(4, 'লাইব্রেরি', IconsaxPlusLinear.book, IconsaxPlusBold.book, isDark, selectedColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData outlineIcon, IconData filledIcon, bool isDark, Color selectedColor) {
    final isSelected = currentIndex == index;
    final activeColor = isDark ? AppColors.darkPrimary : selectedColor;
    final inactiveColor = isDark ? AppColors.darkTextHint : AppColors.textHint;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
