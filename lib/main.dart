import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'databases/preference_handler.dart';
import 'router/app_router.dart';
import 'services/auth_service.dart';
import 'theme.dart';

// =========================================================================
// FUNGSI MAIN MERUPAKAN ENTRY POINT (TITIK AWAL) SAAT APLIKASI FLUTTER DIJALANKAN.
// =========================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  
  // Memuat tema sebelum merender UI
  final isDark = await PreferenceHandler.getThemeIsDark();
  isDarkModeNotifier.value = isDark;
  
  // Memuat sesi pengguna (Authentication State)
  final email = await PreferenceHandler.getSessionEmail();
  final name = await PreferenceHandler.getSessionName();
  final role = await PreferenceHandler.getSessionRole();
  
  if (email != null && role != null) {
     await authService.signIn(email, role, name ?? 'User');
  }

  isDarkModeNotifier.addListener(() async {
    await PreferenceHandler.setThemeIsDark(isDarkModeNotifier.value);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
      ],
      child: const MaestronesiaApp(),
    ),
  );
}

// =========================================================================
// MAESTRONESIAAPP ADALAH ROOT WIDGET APLIKASI YANG MENGGUNAKAN MATERIALAPP.ROUTER
// UNTUK MENDUKUNG SISTEM NAVIGASI BARU (GO_ROUTER).
// =========================================================================
class MaestronesiaApp extends StatefulWidget {
  const MaestronesiaApp({super.key});

  @override
  State<MaestronesiaApp> createState() => _MaestronesiaAppState();
}

class _MaestronesiaAppState extends State<MaestronesiaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.getRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        if (isDark) {
          AppColors.setToDark();
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          );
        } else {
          AppColors.setToLight();
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          );
        }

        return MaterialApp.router(
          title: 'MAESTRONESIA',
          theme: buildAppTheme(),
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        );
      },
    );
  }
}
