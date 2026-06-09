import 'package:shared_preferences/shared_preferences.dart';

// =========================================================================
// PREFERENCEHANDLER ADALAH KELAS PEMBANTU UNTUK MENGELOLA SHAREDPREFERENCES.
// MEMINIMALISASI MAGIC STRINGS DAN MENYEDIAKAN ANGGOTA STATIS UNTUK OPERASI BACA/TULIS.
// =========================================================================
class PreferenceHandler {
  static SharedPreferences? _prefs;

  // KEY CONSTANTS
  static const String _keyThemeIsDark = 'theme_is_dark';
  static const String _keySessionEmail = 'session_email';
  static const String _keySessionName = 'session_name';
  static const String _keySessionRole = 'session_role';
  static const String _keyWebUsers = 'web_users';
  static const String _keyWebBookings = 'web_bookings';

  // Konstruktor privat agar kelas tidak dapat diinstansiasi langsung.
  PreferenceHandler._();

  // Mendapatkan instance SharedPreferences secara asinkronus (cached)
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // =========================================================================
  // TEMA (THEME) PREFERENCES
  // =========================================================================
  static Future<bool> getThemeIsDark() async {
    final prefs = await _instance;
    return prefs.getBool(_keyThemeIsDark) ?? false;
  }

  static Future<bool> setThemeIsDark(bool isDark) async {
    final prefs = await _instance;
    return await prefs.setBool(_keyThemeIsDark, isDark);
  }

  // =========================================================================
  // SESI LOGIN (SESSION) PREFERENCES
  // =========================================================================
  static Future<String?> getSessionEmail() async {
    final prefs = await _instance;
    return prefs.getString(_keySessionEmail);
  }

  static Future<String?> getSessionName() async {
    final prefs = await _instance;
    return prefs.getString(_keySessionName);
  }

  static Future<String?> getSessionRole() async {
    final prefs = await _instance;
    return prefs.getString(_keySessionRole);
  }

  static Future<void> saveSession({
    required String email,
    required String name,
    required String role,
  }) async {
    final prefs = await _instance;
    await prefs.setString(_keySessionEmail, email);
    await prefs.setString(_keySessionName, name);
    await prefs.setString(_keySessionRole, role);
  }

  static Future<void> clearSession() async {
    final prefs = await _instance;
    await prefs.remove(_keySessionEmail);
    await prefs.remove(_keySessionName);
    await prefs.remove(_keySessionRole);
  }

  // =========================================================================
  // WEB SIMULATION DATABASES PREFERENCES
  // =========================================================================
  static Future<String?> getWebUsers() async {
    final prefs = await _instance;
    return prefs.getString(_keyWebUsers);
  }

  static Future<bool> setWebUsers(String json) async {
    final prefs = await _instance;
    return await prefs.setString(_keyWebUsers, json);
  }

  static Future<String?> getWebBookings() async {
    final prefs = await _instance;
    return prefs.getString(_keyWebBookings);
  }

  static Future<bool> setWebBookings(String json) async {
    final prefs = await _instance;
    return await prefs.setString(_keyWebBookings, json);
  }
}
