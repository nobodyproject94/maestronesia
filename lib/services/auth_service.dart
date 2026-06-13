import 'package:flutter/foundation.dart';

// =========================================================================
// AUTHSERVICE ADALAH PROVIDER STATE MANAGEMENT UNTUK MENANGANI SESI PENGGUNA.
// NANTINYA KELAS INI AKAN TERHUBUNG LANGSUNG DENGAN FIREBASE AUTH.
// =========================================================================
class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _role = 'client';
  String _currentUserEmail = '';
  String _currentUserName = '';

  bool get isAuthenticated => _isAuthenticated;
  String get role => _role;
  String get currentUserEmail => _currentUserEmail;
  String get currentUserName => _currentUserName;

  // =========================================================================
  // FUNGSI UNTUK MENSIMULASIKAN LOGIN. (NANTI DIGANTI FIREBASE AUTH SIGN IN)
  // =========================================================================
  Future<void> signIn(String email, String role, String name) async {
    _isAuthenticated = true;
    _currentUserEmail = email;
    _role = role;
    _currentUserName = name;
    notifyListeners();
  }

  // =========================================================================
  // FUNGSI UNTUK LOGOUT.
  // =========================================================================
  Future<void> signOut() async {
    _isAuthenticated = false;
    _currentUserEmail = '';
    _role = 'client';
    _currentUserName = '';
    notifyListeners();
  }

  // =========================================================================
  // FUNGSI MOCK UNTUK MENGGANTI ROLE TANPA LOGIN ULANG (HANYA UNTUK PROTOTYPE).
  // =========================================================================
  void switchRole(String newRole) {
    _role = newRole;
    if (newRole == 'expert') {
      _currentUserName = 'Prof. Dr. Hermanto';
      _currentUserEmail = 'hermanto@expert.com';
    } else {
      _currentUserName = 'Fajar Ramadhan';
      _currentUserEmail = 'client@gmail.com';
    }
    notifyListeners();
  }
}
