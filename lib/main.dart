import 'package:flutter/material.dart';
import 'utils/preference_handler.dart';
import 'databases/database_helper.dart';
import 'models/expert.dart';
import 'screens/billing_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expert_dashboard_screen.dart';
import 'screens/expert_profile_screen.dart';
import 'screens/expert_registration_screen.dart';
import 'screens/history_screen.dart';
import 'screens/live_session_screen.dart';
import 'screens/live_chat_list_screen.dart';
import 'screens/live_chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';
import 'package:flutter/services.dart';

// =========================================================================
// FUNGSI MAIN MERUPAKAN ENTRY POINT (TITIK AWAL) SAAT APLIKASI FLUTTER DIJALANKAN.
// =========================================================================
void main() {
  runApp(const MaestronesiaApp());
}

// =========================================================================
// MAESTRONESIAAPP ADALAH ROOT WIDGET APLIKASI YANG BERSIFAT STATELESS.
// WIDGET INI BERTUGAS MENGATUR TEMA GLOBAL (TERANG/GELAP) SECARA DINAMIS MENGGUNAKAN VALUELISTENABLEBUILDER.
// =========================================================================
class MaestronesiaApp extends StatelessWidget {
  const MaestronesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // VALUELISTENABLEBUILDER MEMANTAU PERUBAHAN STATUS ISDARKMODENOTIFIER.
    // JIKA NILAINYA BERUBAH, BUILDER AKAN DIPANGGIL ULANG UNTUK MEMPERBARUI TEMA APLIKASI.
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        if (isDark) {
          // =========================================================================
          // MENGUBAH SKEMA WARNA GLOBAL KE MODE GELAP (DARK MODE).
          // =========================================================================
          AppColors.setToDark();
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
        } else {
          // =========================================================================
          // MENGUBAH SKEMA WARNA GLOBAL KE MODE TERANG (LIGHT MODE).
          // =========================================================================
          AppColors.setToLight();
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
        }
        return MaterialApp(
          title: 'MAESTRONESIA',
          theme: buildAppTheme(), // MENGAMBIL KONFIGURASI TEMA BERDASARKAN WARNA YANG AKTIF.
          debugShowCheckedModeBanner: false, // MENGHILANGKAN BANNER DEBUG DI POJOK KANAN ATAS SCREEN.
          home: const MainAppController(), // MENGARAHKAN KE CONTROLLER UTAMA APLIKASI UNTUK NAVIGASI SCREEN.
        );
      },
    );
  }
}

// =========================================================================
// MAINAPPCONTROLLER BERFUNGSI SEBAGAI STATE MANAGER SENTRAL UNTUK MENANGANI ROUTING/NAVIGASI MANUAL ANTAR LAYAR.
// =========================================================================
class MainAppController extends StatefulWidget {
  const MainAppController({super.key});

  @override
  State<MainAppController> createState() => _MainAppControllerState();
}

class _MainAppControllerState extends State<MainAppController> {
  // =========================================================================
  // STATE LOKAL UNTUK MENYIMPAN SCREEN AKTIF, PERAN USER, ID EXPERT TERPILIH, DATA BOOKING, DAN SESSION EMAIL/NAMA.
  // =========================================================================
  String _screen =
      'splash'; // DEFAULT SCREEN SAAT PERTAMA KALI DIJALANKAN ADALAH SPLASH SCREEN.
  String _role = 'client'; // PERAN AKTIF PENGGUNA (CLIENT ATAU EXPERT).
  String _originalRole = 'client'; // PERAN ASLI/UTAMA PENGGUNA SAAT LOGIN (CLIENT ATAU EXPERT).
  int _selectedExpertId = 1; // ID EXPERT YANG DIPILIH UNTUK BOOKING/CHAT.
  int _selectedDay = 13; // HARI TERPILIH UNTUK BOOKING.
  String _selectedTime = '09:00 AM'; // WAKTU TERPILIH UNTUK BOOKING.
  String _currentUserEmail = 'client@gmail.com'; // EMAIL USER YANG SEDANG LOGIN.
  String _currentUserName = 'Fajar Ramadhan'; // NAMA USER YANG SEDANG LOGIN.

  @override
  void initState() {
    super.initState();
    _loadSessionAndTheme(); // MEMUAT PREFERENSI TEMA DAN SESI LOGIN PENGGUNA DARI MEMORI LOKAL.
  }

  // =========================================================================
  // FUNGSI ASINKRONUS UNTUK MEMUAT DATA SESSION DARI SHAREDPREFERENCES.
  // =========================================================================
  Future<void> _loadSessionAndTheme() async {
    // =========================================================================
    // MEMBACA STATUS TEMA GELAP (DEFAULT FALSE JIKA BELUM ADA).
    // =========================================================================
    final isDark = await PreferenceHandler.getThemeIsDark();
    isDarkModeNotifier.value = isDark;

    // =========================================================================
    // MENAMBAHKAN LISTENER UNTUK MENDETEKSI PERUBAHAN TEMA SECARA DINAMIS LALU MENYIMPANNYA KE PREFERENCEHANDLER.
    // =========================================================================
    isDarkModeNotifier.addListener(() async {
      await PreferenceHandler.setThemeIsDark(isDarkModeNotifier.value);
    });

    // =========================================================================
    // MEMBACA DATA LOGIN USER (SESSION).
    // =========================================================================
    final email = await PreferenceHandler.getSessionEmail();
    final name = await PreferenceHandler.getSessionName();
    final role = await PreferenceHandler.getSessionRole();

    // =========================================================================
    // JIKA DATA SESSION ADA, LANGSUNG ARAHKAN USER KE DASHBOARD YANG SESUAI (MELEWATI SPLASH/ONBOARDING).
    // =========================================================================
    if (email != null && role != null) {
      setState(() {
        _currentUserEmail = email;
        _currentUserName = name ?? 'User';
        _role = role;
        _originalRole = role; // MENYIMPAN PERAN ASLI PENGGUNA DARI SESSION SHAREDPREFERENCES.
        _screen = role == 'expert' ? 'expert_dashboard' : 'dashboard';
      });
    }
  }

  // =========================================================================
  // FUNGSI ASINKRONUS UNTUK MENANGANI LOGOUT PENGGUNA (MENGHAPUS SESSION DARI SHAREDPREFERENCES).
  // =========================================================================
  Future<void> _handleSignOut() async {
    await PreferenceHandler.clearSession();
    setState(() {
      _currentUserEmail = 'client@gmail.com';
      _currentUserName = 'Fajar Ramadhan';
      _screen = 'onboarding'; // ARAHKAN KEMBALI KE HALAMAN ONBOARDING SETELAH LOGOUT.
    });
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK BERPINDAH KE HALAMAN/LAYAR TERTENTU SECARA DINAMIS.
  // =========================================================================
  void _navigateTo(String screenName) {
    // =========================================================================
    // MENGECEK JIKA TUJUANNYA ADALAH LIVE CHAT DENGAN ID EXPERT SPESIFIK.
    // =========================================================================
    if (screenName.startsWith('live_chat_expert_')) {
      final idStr = screenName.replaceAll('live_chat_expert_', '');
      final id = int.tryParse(idStr) ?? 1;
      setState(() {
        _selectedExpertId = id;
        _screen = 'live_chat';
      });
      return;
    }
    setState(() {
      _screen = screenName;
    });
  }

  // =========================================================================
  // FUNGSI UNTUK MENGALIHKAN PERAN USER SECARA DINAMIS (KHUSUS PERAN ASLI EXPERT).
  // JIKA EXPERT INGIN KONSULTASI, PERAN AKTIF (_ROLE) DIUBAH MENJADI 'CLIENT'
  // DAN PENGGUNA DIALIHKAN KE DASHBOARD CLIENT. JIKA INGIN KEMBALI, PERAN AKTIF
  // DIKEMBALIKAN MENJADI 'EXPERT' DAN DIALIHKAN KEMBALI KE DASHBOARD EXPERT.
  // =========================================================================
  void _switchRole() {
    if (_originalRole == 'expert') {
      setState(() {
        if (_role == 'expert') {
          _role = 'client';
          _screen = 'dashboard';
        } else {
          _role = 'expert';
          _screen = 'expert_dashboard';
        }
      });
    }
  }

  // =========================================================================
  // FUNGSI ASINKRONUS UNTUK MENYIMPAN PESANAN BOOKING BARU KE DALAM DATABASE LOKAL SQLITE.
  // =========================================================================
  void _confirmBooking() async {
    final expert = mockExperts.firstWhere(
      (e) => e.id == _selectedExpertId,
      orElse: () => mockExperts.first,
    );
    await DatabaseHelper.instance.createBooking({
      'user_email': _currentUserEmail,
      'expert_id': expert.id,
      'expert_name': expert.name,
      'topic': expert.expertise,
      'date': 'May $_selectedDay, 2026',
      'time': _selectedTime,
      'status': 'Upcoming',
      'price': expert.price,
    });
    _navigateTo('payment_success'); // PINDAH KE HALAMAN PEMBAYARAN SUKSES.
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // MENCARI EXPERT YANG DIPILIH BERDASARKAN ID EXPERT.
    // =========================================================================
    final currentExpert = mockExperts.firstWhere(
      (e) => e.id == _selectedExpertId,
      orElse: () => mockExperts.first,
    );

    // =========================================================================
    // MENGGUNAKAN PERCABANGAN SWITCH-CASE UNTUK MERENDER HALAMAN BERDASARKAN NILAI _SCREEN.
    // =========================================================================
    switch (_screen) {
      case 'splash':
        return SplashScreen(onFinish: () => _navigateTo('onboarding'));
      case 'onboarding':
        return OnboardingScreen(
          selectedRole: _role,
          onRoleChanged: (newRole) {
            setState(() {
              _role = newRole;
            });
          },
          onBegin: () => _navigateTo('signup'),
          onSignIn: () => _navigateTo('login'),
        );
      case 'login':
        return LoginScreen(
          role: _role,
          onBack: () => _navigateTo('onboarding'),
          onLoginSuccess: (email, name) {
            setState(() {
              _currentUserEmail = email;
              _currentUserName = name;
              _originalRole = _role; // MENETAPKAN PERAN ASLI SESUAI PERAN PILIHAN SAAT LOGIN.
            });
            _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'dashboard');
          },
          onSignUpRedirect: () => _navigateTo('signup'),
        );
      case 'signup':
        return SignUpScreen(
          role: _role,
          onBack: () => _navigateTo('onboarding'),
          onSignUpSuccess: (email, name) {
            setState(() {
              _currentUserEmail = email;
              _currentUserName = name;
              _originalRole = _role; // MENETAPKAN PERAN ASLI SESUAI PERAN PILIHAN SAAT DAFTAR.
            });
            _navigateTo(
              _role == 'expert' ? 'expert_registration' : 'dashboard',
            );
          },
          onLoginRedirect: () => _navigateTo('login'),
        );
      case 'expert_registration':
        return ExpertRegistrationScreen(
          onBack: () => _navigateTo('signup'),
          onRegistrationSuccess: () => _navigateTo('expert_dashboard'),
        );
      case 'dashboard':
        return DashboardScreen(
          onSelectExpert: (id) {
            setState(() {
              _selectedExpertId = id;
            });
            _navigateTo('expert_profile');
          },
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
          isOriginalExpert: _originalRole == 'expert', // MENANDAI JIKA USER ASLINYA ADALAH EXPERT.
          onSwitchRole: _switchRole, // PENGALIH PERAN DARI CLIENT KEMBALI KE EXPERT.
        );
      case 'expert_dashboard':
        return ExpertDashboardScreen(
          onStartLiveSession: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
          onSwitchRole: _switchRole, // PENGALIH PERAN DARI EXPERT KE CLIENT.
        );
      case 'expert_profile':
        return ExpertProfileScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('dashboard'),
          onBook: () => _navigateTo('booking'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'booking':
        return BookingScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('expert_profile'),
          onProceed: (day, time) {
            setState(() {
              _selectedDay = day;
              _selectedTime = time;
            });
            _navigateTo('payment');
          },
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'payment':
        return PaymentScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('booking'),
          onConfirm: _confirmBooking,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'payment_success':
        return PaymentSuccessScreen(
          expert: currentExpert,
          selectedDay: _selectedDay,
          selectedTime: _selectedTime,
          onReturn: () => _navigateTo('dashboard'),
          onViewSessions: () => _navigateTo('history'),
        );
      case 'live_session':
        return LiveSessionScreen(
          expert: currentExpert,
          onHangUp: () =>
              _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'live_chat'),
        );
      case 'live_chat_list':
        return LiveChatListScreen(
          email: _currentUserEmail,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'live_chat':
        return LiveChatScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('live_chat_list'),
          onStartVideoCall: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'profile':
        return ProfileScreen(
          role: _role,
          email: _currentUserEmail,
          name: _currentUserName,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
          isOriginalExpert: _originalRole == 'expert', // MENANDAI JIKA USER ASLINYA ADALAH EXPERT.
          onSwitchRole: _switchRole, // CALLBACK PENGALIKAN PERAN SECARA DINAMIS.
        );
      case 'billing':
        return BillingScreen(
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      case 'history':
        return HistoryScreen(
          email: _currentUserEmail,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
      default:
        return DashboardScreen(
          onSelectExpert: (id) => _navigateTo('expert_profile'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
    }
  }
}
