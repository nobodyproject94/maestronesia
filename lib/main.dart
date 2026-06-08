import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/expert_registration_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expert_dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/chat_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/expert_registration': (context) => const ExpertRegistrationScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/expert_dashboard': (context) => const ExpertDashboardScreen(),
            '/history': (context) => const HistoryScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/billing': (context) => const BillingScreen(),
            '/chat': (context) => const ChatScreen(),
          },
        );
      },
    );
  }
}
