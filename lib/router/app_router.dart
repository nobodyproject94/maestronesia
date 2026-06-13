import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/expert_dashboard_screen.dart';
import '../screens/expert_profile_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/payment_success_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/billing_screen.dart';
import '../screens/live_chat_list_screen.dart';
import '../screens/live_chat_screen.dart';
import '../screens/live_session_screen.dart';
import '../screens/expert_registration_screen.dart';

// =========================================================================
// APPROUTER MENGATUR SELURUH NAVIGASI APLIKASI MENGGUNAKAN GO_ROUTER.
// MENDUKUNG REDIRECT OTOMATIS BERDASARKAN STATUS AUTHENTICATED.
// =========================================================================
class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authService = Provider.of<AuthService>(context, listen: false);
        final isAuth = authService.isAuthenticated;
        
        // List halaman yang bisa diakses tanpa login
        final isAuthRoute = state.uri.path == '/login' || 
                            state.uri.path == '/signup' || 
                            state.uri.path == '/onboarding' || 
                            state.uri.path == '/splash';

        if (!isAuth && !isAuthRoute) {
          return '/onboarding';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => SplashScreen(
            onFinish: () {
              final authService = Provider.of<AuthService>(context, listen: false);
              if (authService.isAuthenticated) {
                if (authService.role == 'expert') {
                  context.go('/expert_dashboard');
                } else {
                  context.go('/dashboard');
                }
              } else {
                context.go('/onboarding');
              }
            },
          ),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(
            onBegin: (role) => context.push('/signup?role=$role'),
            onSignIn: (role) => context.push('/login?role=$role'),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            final role = state.uri.queryParameters['role'] ?? 'client';
            return LoginScreen(
              role: role,
              onBack: () => context.pop(),
              onLoginSuccess: (email, name) async {
                final auth = context.read<AuthService>();
                await auth.signIn(email, role, name);
                if (context.mounted) {
                  if (role == 'expert') {
                    context.go('/expert_dashboard');
                  } else {
                    context.go('/dashboard');
                  }
                }
              },
              onSignUpRedirect: () => context.pushReplacement('/signup?role=$role'),
            );
          },
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) {
            final role = state.uri.queryParameters['role'] ?? 'client';
            return SignUpScreen(
              role: role,
              onBack: () => context.pop(),
              onSignUpSuccess: (email, name) async {
                final auth = context.read<AuthService>();
                await auth.signIn(email, role, name);
                if (context.mounted) {
                  if (role == 'expert') {
                    context.go('/expert_dashboard');
                  } else {
                    context.go('/dashboard');
                  }
                }
              },
              onLoginRedirect: () => context.pushReplacement('/login?role=$role'),
            );
          },
        ),
        GoRoute(
          path: '/expert_registration',
          builder: (context, state) => ExpertRegistrationScreen(
            onBack: () => context.pop(),
            onRegistrationSuccess: () {
              context.go('/expert_dashboard');
            },
          ),
        ),
        // =========================================================================
        // SHELL ROUTE UNTUK HALAMAN YANG MEMILIKI MAIN LAYOUT (BOTTOM NAV & DRAWER)
        // =========================================================================
        ShellRoute(
          builder: (context, state, child) {
            String activeTab = 'dashboard';
            if (state.uri.path.startsWith('/history')) {
              activeTab = 'history';
            } else if (state.uri.path.startsWith('/live_chat')) {
              activeTab = 'live_chat_list';
            } else if (state.uri.path.startsWith('/billing')) {
              activeTab = 'billing';
            } else if (state.uri.path.startsWith('/profile')) {
              activeTab = 'profile';
            }

            return MainLayout(
              activeTab: activeTab,
              onTabChanged: (tab) {
                if (tab == 'dashboard') {
                  final role = context.read<AuthService>().role;
                  if (role == 'expert') {
                    context.go('/expert_dashboard');
                  } else {
                    context.go('/dashboard');
                  }
                } else if (tab == 'history') {
                  context.go('/history');
                } else if (tab == 'live_chat_list') {
                  context.go('/live_chat_list');
                } else if (tab == 'billing') {
                  context.go('/billing');
                } else if (tab == 'profile') {
                  context.go('/profile');
                } else if (tab.startsWith('live_chat_expert_')) {
                  final id = tab.replaceAll('live_chat_expert_', '');
                  context.go('/live_chat/expert/$id');
                } else if (tab.startsWith('live_chat_client_')) {
                  final email = tab.replaceAll('live_chat_client_', '');
                  context.go('/live_chat/client/$email');
                }
              },
              onSignOut: () async {
                final auth = context.read<AuthService>();
                await auth.signOut();
                if (context.mounted) context.go('/onboarding');
              },
              name: context.watch<AuthService>().currentUserName,
              role: context.watch<AuthService>().role,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => DashboardScreen(
                onSelectExpert: (id) => context.go('/expert_profile/$id'),
                onTabChanged: (tab) => context.go('/$tab'), // Simplified
                onSignOut: () {}, // Handled by ShellRoute now
                name: context.watch<AuthService>().currentUserName,
                role: context.watch<AuthService>().role,
              ),
            ),
            GoRoute(
              path: '/expert_dashboard',
              builder: (context, state) => ExpertDashboardScreen(
                onStartLiveSession: () => context.push('/live_session'),
                onTabChanged: (tab) => context.go('/$tab'),
                onSignOut: () {},
                name: context.watch<AuthService>().currentUserName,
              ),
            ),
            GoRoute(
              path: '/history',
              builder: (context, state) => HistoryScreen(
                email: context.watch<AuthService>().currentUserEmail,
                role: context.watch<AuthService>().role,
                name: context.watch<AuthService>().currentUserName,
                onTabChanged: (tab) => context.go('/$tab'),
                onSignOut: () {},
              ),
            ),
            GoRoute(
              path: '/billing',
              builder: (context, state) => BillingScreen(
                onTabChanged: (tab) => context.go('/$tab'),
                onSignOut: () {},
                name: context.watch<AuthService>().currentUserName,
                role: context.watch<AuthService>().role,
              ),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(
                role: context.watch<AuthService>().role,
                email: context.watch<AuthService>().currentUserEmail,
                name: context.watch<AuthService>().currentUserName,
                onTabChanged: (tab) => context.go('/$tab'),
                onSignOut: () async {
                  final auth = context.read<AuthService>();
                  await auth.signOut();
                  if (context.mounted) context.go('/onboarding');
                },
                onProfileUpdated: (name, email) {
                  // TODO update via Provider later
                },
              ),
            ),
            GoRoute(
              path: '/live_chat_list',
              builder: (context, state) => LiveChatListScreen(
                email: context.watch<AuthService>().currentUserEmail,
                onTabChanged: (tab) {
                  if (tab.startsWith('live_chat_expert_')) {
                    final id = tab.replaceAll('live_chat_expert_', '');
                    context.go('/live_chat/expert/$id');
                  } else if (tab.startsWith('live_chat_client_')) {
                    final email = tab.replaceAll('live_chat_client_', '');
                    context.go('/live_chat/client/$email');
                  }
                },
                onSignOut: () {},
                name: context.watch<AuthService>().currentUserName,
                role: context.watch<AuthService>().role,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/expert_profile/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                final expert = mockExperts.firstWhere((e) => e.id == id, orElse: () => mockExperts.first);
                return ExpertProfileScreen(
                  expert: expert,
                  onBack: () => context.pop(),
                  onBook: () => context.push('/booking/$id'),
                  onTabChanged: (tab) => context.go('/$tab'),
                  onSignOut: () {},
                );
              },
            ),
            GoRoute(
              path: '/booking/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                final expert = mockExperts.firstWhere((e) => e.id == id, orElse: () => mockExperts.first);
                return BookingScreen(
                  expert: expert,
                  onBack: () => context.pop(),
                  onProceed: (day, time) => context.push('/payment/$id/$day/$time'),
                  onTabChanged: (tab) => context.go('/$tab'),
                  onSignOut: () {},
                );
              },
            ),
            GoRoute(
              path: '/payment/:id/:day/:time',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                final expert = mockExperts.firstWhere((e) => e.id == id, orElse: () => mockExperts.first);
                final day = int.tryParse(state.pathParameters['day'] ?? '1') ?? 1;
                final time = state.pathParameters['time'] ?? '09:00 AM';
                return PaymentScreen(
                  expert: expert,
                  onBack: () => context.pop(),
                  onConfirm: () => context.pushReplacement('/payment_success/$id/$day/$time'),
                  onTabChanged: (tab) => context.go('/$tab'),
                  onSignOut: () {},
                );
              },
            ),
            GoRoute(
              path: '/payment_success/:id/:day/:time',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                final expert = mockExperts.firstWhere((e) => e.id == id, orElse: () => mockExperts.first);
                final day = int.tryParse(state.pathParameters['day'] ?? '1') ?? 1;
                final time = state.pathParameters['time'] ?? '09:00 AM';
                return PaymentSuccessScreen(
                  expert: expert,
                  selectedDay: day,
                  selectedTime: time,
                  onReturn: () => context.go('/dashboard'),
                  onViewSessions: () => context.go('/history'),
                );
              },
            ),
        GoRoute(
          path: '/live_chat/expert/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                final expert = mockExperts.firstWhere((e) => e.id == id, orElse: () => mockExperts.first);
                return LiveChatScreen(
                  otherUserName: expert.name,
                  otherUserAvatar: expert.avatar,
                  role: context.watch<AuthService>().role,
                  onBack: () => context.go('/live_chat_list'),
                  onStartVideoCall: () => context.push('/live_session'),
                  onTabChanged: (tab) => context.go('/$tab'),
                  onSignOut: () {},
                );
              },
            ),
            GoRoute(
              path: '/live_chat/client/:email',
              builder: (context, state) {
                final email = state.pathParameters['email'] ?? 'Client';
                final chatName = email.split('@').first.toUpperCase();
                final chatAvatar = 'https://ui-avatars.com/api/?name=$chatName&background=0F2038&color=D4AF37';
                return LiveChatScreen(
                  otherUserName: chatName,
                  otherUserAvatar: chatAvatar,
                  role: context.watch<AuthService>().role,
                  onBack: () => context.go('/live_chat_list'),
                  onStartVideoCall: () => context.push('/live_session'),
                  onTabChanged: (tab) => context.go('/$tab'),
                  onSignOut: () {},
                );
              },
        ),
        GoRoute(
          path: '/live_session',
          builder: (context, state) {
            // Hardcoded expert fallback just for signature compatibility
            return LiveSessionScreen(
              expert: mockExperts.first,
              onHangUp: () => context.pop(),
            );
          },
        ),
      ],
    );
  }
}
