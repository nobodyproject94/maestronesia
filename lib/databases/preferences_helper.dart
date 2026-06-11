import 'package:shared_preferences/shared_preferences.dart';

// =========================================================================
// PREFERENCESHELPER ADALAH KELAS PEMBANTU UNTUK MENGELOLA SHAREDPREFERENCES.
// MENYEDIAKAN FUNGSI STATIS UNTUK MENYIMPAN DAN MEMBACA DATA TEMA DAN SESI.
// =========================================================================
class PreferencesHelper {
  static SharedPreferences? _prefs;

  // =========================================================================
  // INISIALISASI INSTANCE SHAREDPREFERENCES SEKALI DI AWAL.
  // =========================================================================
  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // =========================================================================
  // KUNCI-KUNCI (KEYS) UNTUK MENYIMPAN DATA DI SHAREDPREFERENCES.
  // =========================================================================
  static const String keyThemeIsDark = 'theme_is_dark';
  static const String keySessionEmail = 'session_email';
  static const String keySessionName = 'session_name';
  static const String keySessionRole = 'session_role';

  // =========================================================================
  // FUNGSI UNTUK MENYIMPAN STATUS TEMA GELAP/TERANG.
  // =========================================================================
  static Future<bool> setThemeIsDark(bool value) async {
    final p = await prefs;
    return await p.setBool(keyThemeIsDark, value);
  }

  // =========================================================================
  // FUNGSI UNTUK MEMBACA STATUS TEMA GELAP (DEFAULT: FALSE).
  // =========================================================================
  static Future<bool> getThemeIsDark() async {
    final p = await prefs;
    return p.getBool(keyThemeIsDark) ?? false;
  }

  // =========================================================================
  // FUNGSI UNTUK MENYIMPAN SESI LOGIN PENGGUNA.
  // =========================================================================
  static Future<void> saveSession({
    required String email,
    required String name,
    required String role,
  }) async {
    final p = await prefs;
    await p.setString(keySessionEmail, email);
    await p.setString(keySessionName, name);
    await p.setString(keySessionRole, role);
  }

  // =========================================================================
  // FUNGSI UNTUK MEMBACA EMAIL SESI LOGIN PENGGUNA.
  // =========================================================================
  static Future<String?> getSessionEmail() async {
    final p = await prefs;
    return p.getString(keySessionEmail);
  }

  // =========================================================================
  // FUNGSI UNTUK MEMBACA NAMA SESI LOGIN PENGGUNA.
  // =========================================================================
  static Future<String?> getSessionName() async {
    final p = await prefs;
    return p.getString(keySessionName);
  }

  // =========================================================================
  // FUNGSI UNTUK MEMBACA PERAN (ROLE) SESI LOGIN PENGGUNA.
  // =========================================================================
  static Future<String?> getSessionRole() async {
    final p = await prefs;
    return p.getString(keySessionRole);
  }

  // =========================================================================
  // FUNGSI UNTUK MENGHAPUS SESI LOGIN PENGGUNA (LOGOUT).
  // =========================================================================
  static Future<void> clearSession() async {
    final p = await prefs;
    await p.remove(keySessionEmail);
    await p.remove(keySessionName);
    await p.remove(keySessionRole);
  }
}
