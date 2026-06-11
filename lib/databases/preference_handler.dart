import 'package:shared_preferences/shared_preferences.dart';

// =========================================================================
// PREFERENCEHANDLER ADALAH KELAS PEMBANTU UNTUK MENGELOLA SHAREDPREFERENCES.
// MEMINIMALISASI MAGIC STRINGS DAN MENYEDIAKAN ANGGOTA STATIS UNTUK OPERASI BACA/TULIS.
// =========================================================================
class PreferenceHandler {
  static SharedPreferences? _prefs;

  // =========================================================================
  // KEY CONSTANTS UNTUK MENGIDENTIFIKASI PREFERENSI PENYIMPANAN DATA LOKAL SECARA UNIK.
  // =========================================================================
  static const String _keyThemeIsDark = 'theme_is_dark';
  static const String _keySessionEmail = 'session_email';
  static const String _keySessionName = 'session_name';
  static const String _keySessionRole = 'session_role';
  static const String _keyWebUsers = 'web_users';
  static const String _keyWebBookings = 'web_bookings';

  // Konstruktor privat agar kelas tidak dapat diinstansiasi langsung dari luar.
  PreferenceHandler._();

  // =========================================================================
  // MENDAPATKAN INSTANCE SHAREDPREFERENCES SECARA ASINKRONUS (DISIMPAN DI MEMORI/CACHED).
  // =========================================================================
  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // =========================================================================
  // MENGAMBIL STATUS TEMA GELAP (DARK MODE) DARI SHAREDPREFERENCES.
  // DEFAULT ADALAH FALSE JIKA BELUM PERNAH DISIMPAN.
  // =========================================================================
  static Future<bool> getThemeIsDark() async {
    final p = await prefs;
    return p.getBool(_keyThemeIsDark) ?? false;
  }

  // =========================================================================
  // MENYIMPAN STATUS TEMA GELAP (DARK MODE) SECARA ASINKRONUS KE SHAREDPREFERENCES.
  // =========================================================================
  static Future<bool> setThemeIsDark(bool isDark) async {
    final p = await prefs;
    return await p.setBool(_keyThemeIsDark, isDark);
  }

  // =========================================================================
  // MENGAMBIL DATA EMAIL SESI PENGGUNA YANG SEDANG LOGIN.
  // =========================================================================
  static Future<String?> getSessionEmail() async {
    final p = await prefs;
    return p.getString(_keySessionEmail);
  }

  // =========================================================================
  // MENGAMBIL DATA NAMA SESI PENGGUNA YANG SEDANG LOGIN.
  // =========================================================================
  static Future<String?> getSessionName() async {
    final p = await prefs;
    return p.getString(_keySessionName);
  }

  // =========================================================================
  // MENGAMBIL DATA PERAN (ROLE) SESI PENGGUNA YANG SEDANG LOGIN.
  // =========================================================================
  static Future<String?> getSessionRole() async {
    final p = await prefs;
    return p.getString(_keySessionRole);
  }

  // =========================================================================
  // MENYIMPAN DATA SESI LOGIN PENGGUNA (EMAIL, NAMA, PERAN) SECARA BERSAMAAN.
  // =========================================================================
  static Future<void> saveSession({
    required String email,
    required String name,
    required String role,
  }) async {
    final p = await prefs;
    await p.setString(_keySessionEmail, email);
    await p.setString(_keySessionName, name);
    await p.setString(_keySessionRole, role);
  }

  // =========================================================================
  // MENGHAPUS SELURUH DATA SESI LOGIN PENGGUNA SAAT LOGOUT (SIGN OUT).
  // =========================================================================
  static Future<void> clearSession() async {
    final p = await prefs;
    await p.remove(_keySessionEmail);
    await p.remove(_keySessionName);
    await p.remove(_keySessionRole);
  }

  // =========================================================================
  // MENGAMBIL DATA PENGGUNA SIMULASI WEB (FORMAT JSON) DARI SHAREDPREFERENCES.
  // =========================================================================
  static Future<String?> getWebUsers() async {
    final p = await prefs;
    return p.getString(_keyWebUsers);
  }

  // =========================================================================
  // MENYIMPAN DATA PENGGUNA SIMULASI WEB (FORMAT JSON) KE SHAREDPREFERENCES.
  // =========================================================================
  static Future<bool> setWebUsers(String json) async {
    final p = await prefs;
    return await p.setString(_keyWebUsers, json);
  }

  // =========================================================================
  // MENGAMBIL DATA BOOKING SIMULASI WEB (FORMAT JSON) DARI SHAREDPREFERENCES.
  // =========================================================================
  static Future<String?> getWebBookings() async {
    final p = await prefs;
    return p.getString(_keyWebBookings);
  }

  // =========================================================================
  // MENYIMPAN DATA BOOKING SIMULASI WEB (FORMAT JSON) KE SHAREDPREFERENCES.
  // =========================================================================
  static Future<bool> setWebBookings(String json) async {
    final p = await prefs;
    return await p.setString(_keyWebBookings, json);
  }
}
