import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MaestronesiaApp());
}

class MaestronesiaApp extends StatelessWidget {
  const MaestronesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        if (isDark) {
          AppColors.setToDark();
        } else {
          AppColors.setToLight();
        }
        return MaterialApp(
          title: 'MAESTRONESIA',
          theme: buildAppTheme(),
          debugShowCheckedModeBanner: false,
          home: const MainAppController(),
        );
      },
    );
  }
}

class MainAppController extends StatefulWidget {
  const MainAppController({super.key});

  @override
  State<MainAppController> createState() => _MainAppControllerState();
}

class _MainAppControllerState extends State<MainAppController> {
  String _screen = 'splash'; // splash, onboarding, login, signup, expert_registration, dashboard, ...
  String _role = 'client'; // client, expert
  int _selectedExpertId = 1;
  int _selectedDay = 13;
  String _selectedTime = '09:00 AM';
  String _currentUserEmail = 'client@gmail.com';
  String _currentUserName = 'Fajar Ramadhan';

  @override
  void initState() {
    super.initState();
    _loadSessionAndTheme();
  }

  Future<void> _loadSessionAndTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme setting
    final isDark = prefs.getBool('theme_is_dark') ?? true;
    isDarkModeNotifier.value = isDark;

    // Persist theme settings dynamically on toggling
    isDarkModeNotifier.addListener(() async {
      final p = await SharedPreferences.getInstance();
      await p.setBool('theme_is_dark', isDarkModeNotifier.value);
    });

    // Load login session
    final email = prefs.getString('session_email');
    final name = prefs.getString('session_name');
    final role = prefs.getString('session_role');

    if (email != null && role != null) {
      setState(() {
        _currentUserEmail = email;
        _currentUserName = name ?? 'User';
        _role = role;
        // Skip splash/onboarding if session is restored
        _screen = role == 'expert' ? 'expert_dashboard' : 'dashboard';
      });
    }
  }

  Future<void> _handleSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_email');
    await prefs.remove('session_name');
    await prefs.remove('session_role');
    setState(() {
      _currentUserEmail = 'client@gmail.com';
      _currentUserName = 'Fajar Ramadhan';
      _screen = 'onboarding';
    });
  }

  void _navigateTo(String screenName) {
    setState(() {
      _screen = screenName;
    });
  }

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
    _navigateTo('payment_success');
  }

  @override
  Widget build(BuildContext context) {
    final currentExpert = mockExperts.firstWhere(
      (e) => e.id == _selectedExpertId,
      orElse: () => mockExperts.first,
    );

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
        );
      case 'expert_dashboard':
        return ExpertDashboardScreen(
          onStartLiveSession: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
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
              _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'dashboard'),
        );
      case 'profile':
        return ProfileScreen(
          role: _role,
          email: _currentUserEmail,
          name: _currentUserName,
          onTabChanged: _navigateTo,
          onSignOut: _handleSignOut,
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
