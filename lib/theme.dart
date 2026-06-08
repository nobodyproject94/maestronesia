import 'package:flutter/material.dart';

// PERBAIKAN DI SINI: Diubah dari true menjadi false agar aplikasi otomatis mulai dalam Light Mode
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

class AppColors {
  static bool get _isDark => isDarkModeNotifier.value;

  static Color get background =>
      _isDark ? const Color(0xFF131D24) : Colors.transparent;
  static Color get surface =>
      _isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05);
  static Color get secondary =>
      _isDark ? const Color(0xFF2C363E) : Colors.white.withOpacity(0.1);
  static Color get textPrimary =>
      _isDark ? const Color(0xFFDAE4EF) : Colors.white;
  static Color get textSecondary =>
      _isDark ? const Color(0xFFBBCAC1) : Colors.white.withOpacity(0.7);
  static const Color gold = Color(0xFFE6BC6A);
  static const Color cardBorder = Color(0x333C4A43);
  static const Color success = Color(0xFFE6BC6A); // consistent gold lite
  static const Color error = Color(0xFFEF4444);

  static void setToDark() {}
  static void setToLight() {}
}

class MaestronesiaBackground extends StatelessWidget {
  final Widget child;
  const MaestronesiaBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        if (isDark) {
          return Container(color: const Color(0xFF131D24), child: child);
        } else {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B141C),
                  Color(0xFF1E4578),
                  Color(0xFF6C9DDC),
                ],
              ),
            ),
            child: child,
          );
        }
      },
    );
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.gold,
    colorScheme: ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.gold,
      secondary: AppColors.secondary,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'Outfit',
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      ),
    ),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.12),
        foregroundColor: AppColors.gold,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        side: const BorderSide(color: AppColors.gold, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    ),
  );
}
