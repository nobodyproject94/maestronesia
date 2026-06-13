import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// SHOWCUSTOMSNACKBAR ADALAH FUNGSI KUSTOM UNTUK MENAMPILKAN SNACKBAR YANG
// KONSISTEN, MEMILIKI KONTRAS TINGGI, DAN DISETTING SECARA DINAMIS UNTUK
// DARK MODE DAN LIGHT MODE.
// =========================================================================
void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  final isDark = isDarkModeNotifier.value;

  // Definisikan warna-warna berdasarkan mode (Dark vs Light) dan status (Error vs Success)
  Color backgroundColor;
  Color textColor;
  Color iconColor;
  BorderSide borderSide;
  IconData icon;

  if (isError) {
    if (isDark) {
      // Dark Mode - Error: Red solid background with high contrast white text
      backgroundColor = const Color(0xFFEF4444);
      textColor = Colors.white;
      iconColor = Colors.white;
      borderSide = BorderSide.none;
      icon = Icons.error_outline_rounded;
    } else {
      // Light Mode - Error: Red solid background with border for visual distinction
      backgroundColor = const Color(0xFFEF4444);
      textColor = Colors.white;
      iconColor = Colors.white;
      borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1.5);
      icon = Icons.error_outline_rounded;
    }
  } else {
    if (isDark) {
      // Dark Mode - Success: Gold background with dark charcoal text (consistent with buttons)
      backgroundColor = AppColors.gold;
      textColor = const Color(0xFF131D24);
      iconColor = const Color(0xFF131D24);
      borderSide = BorderSide.none;
      icon = Icons.check_circle_outline_rounded;
    } else {
      // Light Mode - Success: Solid gold background with dark charcoal text
      backgroundColor = AppColors.gold;
      textColor = const Color(0xFF0B141C);
      iconColor = const Color(0xFF0B141C);
      borderSide = BorderSide(color: const Color(0xFF0B141C).withValues(alpha: 0.1), width: 1.5);
      icon = Icons.check_circle_outline_rounded;
    }
  }

  // Menyembunyikan snackbar aktif saat ini agar dapat merespon aksi baru secara instan
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: isDark ? 4.0 : 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: borderSide,
      ),
      content: Row(
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
      duration: const Duration(seconds: 3),
    ),
  );
}
