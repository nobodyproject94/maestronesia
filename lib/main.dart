import 'package:flutter/material.dart';
import 'databases/preference_handler.dart';
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
  String _role = 'client'; // PERAN PENGGUNA (CLIENT ATAU EXPERT).
  int _selectedExpertId = 1; // ID EXPERT YANG DIPILIH UNTUK BOOKING/CHAT.
  int _selectedDay = 13; // HARI TERPILIH UNTUK BOOKING.
  String _selectedTime = '09:00 AM'; // WAKTU TERPILIH UNTUK BOOKING.
  String _currentUserEmail = 'client@gmail.com'; // EMAIL USER YANG SEDANG LOGIN.
  String _currentUserName = 'Fajar Ramadhan'; // NAMA USER YANG SEDANG LOGIN.
  final List<String> _history = []; // STACK HISTORI UNTUK INTERSEPSI NAVIGASI TOMBOL KEMBALI (BACK BUTTON).

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
    // MENAMBAHKAN LISTENER UNTUK MENDETEKSI PERUBAHAN TEMA SECARA DINAMIS LALU MENYIMPANNYA KE SHAREDPREFERENCES.
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
        if (_screen != 'live_chat') {
          _history.add(_screen);
        }
        _screen = 'live_chat';
      });
      return;
    }

    if (_screen == screenName) return;

    setState(() {
      // =========================================================================
      // BERSIHKAN HISTORI KETIKA PINDAH KE HALAMAN UTAMA AGAR TOMBOL BACK EXIT APLIKASI.
      // =========================================================================
      if (screenName == 'dashboard' ||
          screenName == 'expert_dashboard' ||
          screenName == 'onboarding') {
        _history.clear();
      } else {
        // =========================================================================
        // JANGAN MASUKKAN SCREEN TRANSIEN ATAU DUPLIKAT KE DALAM HISTORI.
        // =========================================================================
        if (_screen != 'splash' && _screen != 'payment_success') {
          _history.add(_screen);
        }
      }
      _screen = screenName;
    });
  }

  // =========================================================================
  // MENGECEK APAKAH LAYAR SEKARANG MERUPAKAN ROOT SCREEN (DASHBOARD/ONBOARDING/SPLASH)
  // JIKA BENAR, MAKA TOMBOL BACK AKAN DILEPASKAN KELUAR APLIKASI.
  // =========================================================================
  bool _isRootScreen() {
    return _screen == 'splash' ||
        _screen == 'onboarding' ||
        _screen == 'dashboard' ||
        _screen == 'expert_dashboard';
  }

  // =========================================================================
  // FUNGSI UNTUK KEMBALI KE HALAMAN SEBELUMNYA BERDASARKAN STACK HISTORI NAVIGASI.
  // =========================================================================
  void _goBack() {
    // =========================================================================
    // JIKA KITA BERADA DI HALAMAN FILTER TAB UTAMA LAIN, KEMBALIKAN KE DASHBOARD UTAMA.
    // =========================================================================
    if (_screen == 'history' ||
        _screen == 'billing' ||
        _screen == 'profile' ||
        _screen == 'live_chat_list') {
      setState(() {
        _history.clear();
        _screen = 'dashboard';
      });
      return;
    }

    // =========================================================================
    // KHUSUS HALAMAN SUKSES PEMBAYARAN, JIKA KEMBALI ARAHKAN KE DASHBOARD.
    // =========================================================================
    if (_screen == 'payment_success') {
      setState(() {
        _history.clear();
        _screen = 'dashboard';
      });
      return;
    }

    // =========================================================================
    // JIKA ADA STACK HISTORI SEBELUMNYA, POP DAN TAMPILKAN LAYAR TERSEBUT.
    // =========================================================================
    if (_history.isNotEmpty) {
      final previousScreen = _history.removeLast();
      setState(() {
        _screen = previousScreen;
      });
      return;
    }

    // =========================================================================
    // FALLBACK AMAN: KEMBALI KE HOME YANG SESUAI.
    // =========================================================================
    setState(() {
      if (_screen == 'login' || _screen == 'signup' || _screen == 'expert_registration') {
        _screen = 'onboarding';
      } else {
        _screen = _role == 'expert' ? 'expert_dashboard' : 'dashboard';
      }
    });
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
    // MENGGUNAKAN PERCABANGAN SWITCH-CASE UNTUK MENENTUKAN WIDGET AKTIF.
    // =========================================================================
    Widget activeWidget;
    switch (_screen) {
      case 'splash':
        activeWidget = SplashScreen(onFinish: () => _navigateTo('onboarding'));
        break;
      case 'onboarding':
        activeWidget = OnboardingScreen(
          selectedRole: _role,
          onRoleChanged: (newRole) {
            setState(() {
              _role = newRole;
            });
          },
          onBegin: () => _navigateTo('signup'),
          onSignIn: () => _navigateTo('login'),
        );
        break;
      case 'login':
        activeWidget = LoginScreen(
          role: _role,
          onBack: _goBack,
          onLoginSuccess: (email, name) {
            setState(() {
              _currentUserEmail = email;
              _currentUserName = name;
            });
            _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'dashboard');
          },
          onSignUpRedirect: () => _navigateTo('signup'),
        );
        break;
      case 'signup':
        activeWidget = SignUpScreen(
          role: _role,
          onBack: _goBack,
          onSignUpSuccess: (email, name) {
            setState(() {
              _currentUserEmail = email;
              _currentUserName = name;
            });
            _navigateTo(
              _role == 'expert' ? 'expert_registration' : 'dashboard',
            );
          },
          onLoginRedirect: () => _navigateTo('login'),
        );
        break;
      case 'expert_registration':
        activeWidget = ExpertRegistrationScreen(
          onBack: _goBack,
          onRegistrationSuccess: () => _navigateTo('expert_dashboard'),
        );
        break;
      case 'dashboard':
        activeWidget = DashboardScreen(
          onSelectExpert: (id) {
            setState(() {
              _selectedExpertId = id;
            });
            _navigateTo('expert_profile');
          },
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'expert_dashboard':
        activeWidget = ExpertDashboardScreen(
          onStartLiveSession: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'expert_profile':
        activeWidget = ExpertProfileScreen(
          expert: currentExpert,
          onBack: _goBack,
          onBook: () => _navigateTo('booking'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'booking':
        activeWidget = BookingScreen(
          expert: currentExpert,
          onBack: _goBack,
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
        break;
      case 'payment':
        activeWidget = PaymentScreen(
          expert: currentExpert,
          onBack: _goBack,
          onConfirm: _confirmBooking,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'payment_success':
        activeWidget = PaymentSuccessScreen(
          expert: currentExpert,
          selectedDay: _selectedDay,
          selectedTime: _selectedTime,
          onReturn: () => _navigateTo('dashboard'),
          onViewSessions: () => _navigateTo('history'),
        );
        break;
      case 'live_session':
        activeWidget = LiveSessionScreen(
          expert: currentExpert,
          onHangUp: () =>
              _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'live_chat'),
        );
        break;
      case 'live_chat_list':
        activeWidget = LiveChatListScreen(
          email: _currentUserEmail,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'live_chat':
        activeWidget = LiveChatScreen(
          expert: currentExpert,
          onBack: _goBack,
          onStartVideoCall: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'profile':
        activeWidget = ProfileScreen(
          role: _role,
          email: _currentUserEmail,
          name: _currentUserName,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
          onProfileUpdated: (name, email) {
            setState(() {
              _currentUserName = name;
              _currentUserEmail = email;
            });
          },
        );
        break;
      case 'billing':
        activeWidget = BillingScreen(
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      case 'history':
        activeWidget = HistoryScreen(
          email: _currentUserEmail,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
      default:
        activeWidget = DashboardScreen(
          onSelectExpert: (id) => _navigateTo('expert_profile'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
        );
        break;
    }

    // =========================================================================
    // MEMBUNGKUS WIDGET DENGAN POPSCOPE UNTUK MENCEGAH APLIKASI KELUAR SAAT BACK BUTTON DITEKAN.
    // =========================================================================
    return PopScope(
      canPop: _isRootScreen(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBack();
      },
      child: activeWidget,
    );
  }
}
