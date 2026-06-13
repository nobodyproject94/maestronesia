import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// SHOWCUSTOMSNACKBAR ADALAH FUNGSI KUSTOM UNTUK MENAMPILKAN SNACKBAR YANG
// KONSISTEN, MEMILIKI KONTRAS TINGGI, DAN DISETTING SECARA DINAMIS UNTUK
// DARK MODE DAN LIGHT MODE.
// =========================================================================
void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  final isDark = isDarkModeNotifier.value;

  Color textColor;
  Color iconColor;
  IconData icon;
  Gradient? backgroundGradient;
  Color? fallbackColor;
  BorderSide borderSide;

  if (isError) {
    if (isDark) {
      // Dark Mode - Error
      fallbackColor = const Color(0xFFEF4444);
      textColor = Colors.white;
      iconColor = Colors.white;
      borderSide = BorderSide.none;
      icon = Icons.error_outline_rounded;
    } else {
      // Light Mode - Error
      fallbackColor = const Color(0xFFEF4444);
      textColor = Colors.white;
      iconColor = Colors.white;
      borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1.5);
      icon = Icons.error_outline_rounded;
    }
  } else {
    if (isDark) {
      // Dark Mode - Success
      fallbackColor = AppColors.gold;
      textColor = const Color(0xFF131D24);
      iconColor = const Color(0xFF131D24);
      borderSide = BorderSide.none;
      icon = Icons.check_circle_outline_rounded;
    } else {
      // Light Mode - Success: Gradient background like the light mode theme
      backgroundGradient = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0B141C),
          Color(0xFF1E4578),
          Color(0xFF6C9DDC),
        ],
      );
      textColor = AppColors.gold;
      iconColor = AppColors.gold;
      borderSide = const BorderSide(color: AppColors.gold, width: 1.5);
      icon = Icons.check_circle_outline_rounded;
    }
  }

  // Menyembunyikan snackbar aktif saat ini agar dapat merespon aksi baru secara instan
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent, // Background dihandle oleh Container
      behavior: SnackBarBehavior.floating,
      elevation: 0.0, // Shadow dihandle oleh Container
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: fallbackColor,
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(16),
          border: borderSide.style == BorderStyle.none
              ? null
              : Border.all(color: borderSide.color, width: borderSide.width),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
