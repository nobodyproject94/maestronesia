import 'package:flutter/material.dart';

// =========================================================================
// ISDARKMODENOTIFIER ADALAH VALUENOTIFIER GLOBAL YANG MENYIMPAN STATUS APAKAH APLIKASI SEDANG DALAM MODE GELAP ATAU TERANG.
// INISIALISASI DEFAULT ADALAH FALSE (LIGHT MODE).
// =========================================================================
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

// =========================================================================
// APPCOLORS MENDEFINISIKAN WARNA-WARNA APLIKASI YANG BERADAPTASI SECARA DINAMIS BERDASARKAN STATUS TEMA SAAT INI (_ISDARK).
// =========================================================================
class AppColors {
  // =========================================================================
  // GETTER PEMBANTU UNTUK MENGECEK APAKAH TEMA GELAP SEDANG AKTIF.
  // =========================================================================
  static bool get _isDark => isDarkModeNotifier.value;

  // =========================================================================
  // WARNA LATAR BELAKANG UTAMA APLIKASI.
  // =========================================================================
  static Color get background =>
      _isDark ? const Color(0xFF131D24) : Colors.transparent;

  // =========================================================================
  // WARNA PERMUKAAN (SEPERTI LATAR BELAKANG KARTU ATAU KONTAINER).
  // =========================================================================
  static Color get surface =>
      _isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05);

  // =========================================================================
  // WARNA SEKUNDER UNTUK LATAR BELAKANG TOMBOL NON-UTAMA ATAU AREA INPUT.
  // =========================================================================
  static Color get secondary =>
      _isDark ? const Color(0xFF2C363E) : Colors.white.withOpacity(0.1);

  // =========================================================================
  // WARNA TEKS UTAMA YANG KONTRAS DENGAN LATAR BELAKANG.
  // =========================================================================
  static Color get textPrimary =>
      _isDark ? const Color(0xFFDAE4EF) : Colors.white;

  // =========================================================================
  // WARNA TEKS SEKUNDER UNTUK INFORMASI TAMBAHAN/DESKRIPSI (BERWARNA ABU-ABU/REDUP).
  // =========================================================================
  static Color get textSecondary =>
      _isDark ? const Color(0xFFBBCAC1) : Colors.white.withOpacity(0.7);

  // =========================================================================
  // WARNA AKSEN EMAS UTAMA APLIKASI.
  // =========================================================================
  static const Color gold = Color(0xFFE6BC6A);

  // =========================================================================
  // WARNA GARIS TEPI (BORDER) KARTU.
  // =========================================================================
  static const Color cardBorder = Color(0x333C4A43);

  // =========================================================================
  // WARNA PENANDA SUKSES.
  // =========================================================================
  static const Color success = Color(0xFFE6BC6A); // CONSISTENT GOLD LITE

  // =========================================================================
  // WARNA PENANDA ERROR/KESALAHAN.
  // =========================================================================
  static const Color error = Color(0xFFEF4444);

  static void setToDark() {}
  static void setToLight() {}
}

// =========================================================================
// MAESTRONESIABACKGROUND ADALAH WIDGET PEMBUNGKUS DEKORASI LATAR BELAKANG.
// WIDGET INI MERENDER WARNA SOLID JIKA DALAM MODE GELAP, DAN GRADIEN LINEAR KUSTOM BIRU TUA/EMAS JIKA DALAM MODE TERANG.
// =========================================================================
class MaestronesiaBackground extends StatelessWidget {
  final Widget child;
  const MaestronesiaBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        if (isDark) {
          // =========================================================================
          // LATAR BELAKANG SOLID BIRU GELAP UNTUK DARK MODE.
          // =========================================================================
          return Container(color: const Color(0xFF131D24), child: child);
        } else {
          // =========================================================================
          // LATAR BELAKANG GRADIEN BIRU/EMAS YANG KHAS UNTUK LIGHT MODE.
          // =========================================================================
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

// =========================================================================
// BUILDAPPTHEME MEMBANGUN KONFIGURASI TEMA GLOBAL FLUTTER (THEMEDATA)
// MENGGUNAKAN WARNA-WARNA DINAMIS DARI APPCOLORS DAN FONT KUSTOM (OUTFIT DAN INTER).
// =========================================================================
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
    // =========================================================================
    // PENGATURAN TIPOGRAFI TEKS SECARA GLOBAL.
    // =========================================================================
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
    // =========================================================================
    // KONFIGURASI TEMA GLOBAL UNTUK ELEVATEDBUTTON DI SELURUH APLIKASI.
    // =========================================================================
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
