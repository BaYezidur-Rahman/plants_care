import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextPrimary 
            : AppColors.textPrimary,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextPrimary 
            : AppColors.textPrimary,
      );

  static TextStyle titleLarge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextPrimary 
            : AppColors.textPrimary,
      );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextPrimary 
            : AppColors.textPrimary,
      );

  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextPrimary 
            : AppColors.textPrimary,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextSecondary 
            : AppColors.textSecondary,
      );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.darkTextHint 
            : AppColors.textHint,
      );
}
