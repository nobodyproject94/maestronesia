import 'package:flutter/material.dart';
import 'theme.dart';
import 'models/expert.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/expert_registration_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expert_profile_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/live_session_screen.dart';
import 'screens/expert_dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const MaestronesiaApp());
}

class MaestronesiaApp extends StatelessWidget {
  const MaestronesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAESTRONESIA',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const MainAppController(),
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

  void _navigateTo(String screenName) {
    setState(() {
      _screen = screenName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentExpert = mockExperts.firstWhere(
      (e) => e.id == _selectedExpertId,
      orElse: () => mockExperts.first,
    );

    switch (_screen) {
      case 'splash':
        return SplashScreen(
          onFinish: () => _navigateTo('onboarding'),
        );
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
          onLoginSuccess: () {
            _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'dashboard');
          },
          onSignUpRedirect: () => _navigateTo('signup'),
        );
      case 'signup':
        return SignUpScreen(
          role: _role,
          onBack: () => _navigateTo('onboarding'),
          onSignUpSuccess: () {
            _navigateTo(_role == 'expert' ? 'expert_registration' : 'dashboard');
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
          onSignOut: () => _navigateTo('onboarding'),
        );
      case 'expert_dashboard':
        return ExpertDashboardScreen(
          onStartLiveSession: () => _navigateTo('live_session'),
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
        );
      case 'expert_profile':
        return ExpertProfileScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('dashboard'),
          onBook: () => _navigateTo('booking'),
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
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
          onSignOut: () => _navigateTo('onboarding'),
        );
      case 'payment':
        return PaymentScreen(
          expert: currentExpert,
          onBack: () => _navigateTo('booking'),
          onConfirm: () => _navigateTo('payment_success'),
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
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
          onHangUp: () => _navigateTo(_role == 'expert' ? 'expert_dashboard' : 'dashboard'),
        );
      case 'profile':
        return ProfileScreen(
          role: _role,
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
        );
      case 'billing':
        return BillingScreen(
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
        );
      case 'history':
        return HistoryScreen(
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
        );
      default:
        return DashboardScreen(
          onSelectExpert: (id) => _navigateTo('expert_profile'),
          onTabChanged: _navigateTo,
          onSignOut: () => _navigateTo('onboarding'),
        );
    }
  }
}
