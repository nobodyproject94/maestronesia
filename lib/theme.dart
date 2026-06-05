import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B141C);
  static const Color surface = Color(0xFF172128);
  static const Color secondary = Color(0xFF2C363E);
  static const Color textPrimary = Color(0xFFDAE4EF);
  static const Color textSecondary = Color(0xFFBBCAC1);
  static const Color gold = Color(0xFFE6BC6A);
  static const Color cardBorder = Color(0x333C4A43);
  static const Color success = Color(0xFFE6BC6A); // consistent gold lite
  static const Color error = Color(0xFFEF4444);
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.gold,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.gold,
      secondary: AppColors.secondary,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.textPrimary, fontFamily: 'Outfit', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.textPrimary, fontFamily: 'Outfit', fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
    ),
    useMaterial3: true,
  );
}
