import 'package:flutter/material.dart';

class AppColors {
  // LIGHT MODE:
  static const primary = Color(0xFF2D6A4F); // deep forest green
  static const primaryLight = Color(0xFF52B788); // medium green
  static const accent = Color(0xFF95D5B2); // soft mint
  static const accentWarm = Color(0xFFD8F3DC); // light mint
  static const background = Color(0xFFF8FAF8);
  static const surface = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFF0F7F0);
  static const textPrimary = Color(0xFF1B2F1E);
  static const textSecondary = Color(0xFF4A6741);
  static const textHint = Color(0xFF8FAF8A);
  static const warning = Color(0xFFF4A261);
  static const error = Color(0xFFE76F51);
  static const success = Color(0xFF40916C);
  static const water = Color(0xFF48CAE4);
  static const soil = Color(0xFFBC6C25);
  static const sun = Color(0xFFFFB703);
  static const divider = Color(0xFFE8F5E9);

  // DARK MODE:
  static const darkBackground = Color(0xFF121A13);
  static const darkSurface = Color(0xFF1B2A1E);
  static const darkCardBg = Color(0xFF243325);
  static const darkPrimary = Color(0xFF52B788);
  static const darkTextPrimary = Color(0xFFD8F3DC);
  static const darkTextSecondary = Color(0xFF95D5B2);
  static const darkTextHint = Color(0xFF4A6741);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getCardColor(bool isDark) {
    return isDark ? darkCardBg : cardBg;
  }

  static Color getTextColor(bool isDark) {
    return isDark ? darkTextPrimary : textPrimary;
  }
}
