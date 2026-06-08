import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String activeTab;
  final bool showNavbar;

  const MainLayout({
    super.key,
    required this.child,
    required this.activeTab,
    this.showNavbar = true,
  });

  void _changeTab(BuildContext context, String tabName) async {
    HapticFeedback.lightImpact();
    if (activeTab != tabName) {
      if (tabName == 'dashboard') {
        final prefs = await SharedPreferences.getInstance();
        final role = prefs.getString('session_role') ?? 'client';
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            role == 'expert' ? '/expert_dashboard' : '/dashboard',
          );
        }
      } else {
        Navigator.pushReplacementNamed(context, '/$tabName');
      }
    }
  }

  void _handleSignOut(BuildContext context) async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isDarkModeNotifier.value = false;
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    // FIX UTAMA: Membungkus seluruh layout agar sensitif terhadap perubahan dark/light mode
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        if (isDesktop) {
          return _buildDesktopLayout(context, isDark);
        } else {
          return _buildMobileLayout(context, isDark);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.background : Colors.transparent,
      body: Container(
        // Kondisi Light Mode: Memunculkan gradasi Biru Tua ke Biru Muda Elektrik
        decoration: isDark
            ? null
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B1528), // Deep Navy Blue atas
                    Color(0xFF1E3A8A), // Soft Electric Blue bawah
                  ],
                ),
              ),
        child: Row(
          children: [
            // Sidebar Desktop
            Container(
              width: 260,
              // Kondisi Light mode: Sidebar menjadi transparan total
              color: isDark ? AppColors.surface : Colors.transparent,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header/Logo
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surface
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.menu_book,
                          color: AppColors.gold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Maestro',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Navigation Tabs
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSidebarItem(
                          context,
                          'dashboard',
                          'Explore',
                          Icons.explore_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          context,
                          'chat',
                          'Chat',
                          Icons.chat_bubble_outline,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          context,
                          'history',
                          'History',
                          Icons.history,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          context,
                          'billing',
                          'Wallet',
                          Icons.account_balance_wallet_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          context,
                          'profile',
                          'Profile',
                          Icons.person_outline,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  // Sidebar Footer (Profile Info & Logout)
                  Divider(
                    color: isDark ? AppColors.cardBorder : Colors.white10,
                    height: 24,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop',
                        ),
                        backgroundColor: AppColors.gold.withOpacity(0.1),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fajar Ramadhan',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Client · Engineering',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          isDarkModeNotifier.value = !isDarkModeNotifier.value;
                        },
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: AppColors.textSecondary,
                        ),
                        tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
                      ),
                      IconButton(
                        onPressed: () => _handleSignOut(context),
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        tooltip: 'Sign Out',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Main content area
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    String id,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = activeTab == id;
    return InkWell(
      onTap: () => _changeTab(context, id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // KONDISI SELEKSI: Jika Light Mode, background kapsul diganti transparan total
          color: isSelected
              ? (isDark ? AppColors.gold : Colors.transparent)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (isDark ? Colors.black : AppColors.gold)
                  : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? (isDark ? Colors.black : AppColors.gold)
                      : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // KONDISI SELEKSI LIGHT MODE: Menampilkan bulatan circle emas kecil di sebelah kanan menu aktif
            if (isSelected && !isDark)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTabTitle(String tab) {
    switch (tab) {
      case 'chat':
        return 'Inbox Messages';
      case 'history':
        return 'Session History';
      case 'billing':
        return 'Billing & Wallet';
      case 'profile':
        return 'Profile Settings';
      case 'dashboard':
      default:
        return 'MAESTRONESIA';
    }
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Container(
      decoration: isDark
          ? const BoxDecoration(color: Color(0xFF0B141C))
          : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1528), // Deep Navy Blue atas
                  Color(0xFF1E3A8A), // Soft Electric Blue bawah
                ],
              ),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: false,
        extendBodyBehindAppBar: false,
        appBar: showNavbar
            ? AppBar(
                backgroundColor: isDark ? const Color(0xFF172128) : Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                title: Text(
                  _getTabTitle(activeTab),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              )
            : null,
        drawer: showNavbar ? _buildCustomDrawer(context, isDark) : null,
        body: showNavbar
            ? BottomBar(
                body: child,
                layout: BottomBarLayout(
                  width: MediaQuery.of(context).size.width - 32,
                  borderRadius: BorderRadius.circular(24),
                  offset: 16,
                  respectSafeArea: true,
                ),
                theme: BottomBarThemeData(
                  barDecoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFF172128).withOpacity(0.9) 
                        : const Color(0xFF0B1528).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark 
                          ? AppColors.cardBorder 
                          : Colors.white.withOpacity(0.12),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFloatingNavItem(context, 'dashboard', Icons.explore_outlined, Icons.explore, 'Explore', isDark),
                          _buildFloatingNavItem(context, 'chat', Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat', isDark),
                          _buildFloatingNavItem(context, 'history', Icons.history_outlined, Icons.history, 'Sessions', isDark),
                          _buildFloatingNavItem(context, 'billing', Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Wallet', isDark),
                          _buildFloatingNavItem(context, 'profile', Icons.person_outline, Icons.person, 'Profile', isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : child,
      ),
    );
  }



  Widget _buildFloatingNavItem(
    BuildContext context,
    String id,
    IconData icon,
    IconData activeIcon,
    String label,
    bool isDark,
  ) {
    final isSelected = activeTab == id;
    final color = isSelected 
        ? AppColors.gold 
        : (isDark ? AppColors.textSecondary : Colors.white70);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _changeTab(context, id),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }
          final prefs = snapshot.data!;
          final role = prefs.getString('session_role') ?? 'client';

          return Container(
            decoration: isDark
                ? const BoxDecoration(color: Color(0xFF0B141C))
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0B141C),
                        Color(0xFF1E4578),
                        Color(0xFF6C9DDC),
                      ],
                    ),
                  ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Custom Drawer Header matching Image 3
                Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF0F2033),
                              Color(0xFF0B141C),
                            ],
                          )
                        : null,
                    color: isDark ? null : Colors.white.withOpacity(0.05),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "MAESTRONESIA",
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Be your maestro",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Drawer Items matching Image 3
                _buildDrawerItem(
                  context: context,
                  id: 'dashboard',
                  title: role == 'expert' ? 'Dashboard' : 'Explore',
                  subtitle: role == 'expert' ? 'Expert overview' : 'Home overview',
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  isSelected: activeTab == 'dashboard',
                  isDark: isDark,
                ),
                _buildDrawerItem(
                  context: context,
                  id: 'chat',
                  title: 'Chat',
                  subtitle: 'Messages & inbox',
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  isSelected: activeTab == 'chat',
                  isDark: isDark,
                ),
                _buildDrawerItem(
                  context: context,
                  id: 'history',
                  title: 'Sessions',
                  subtitle: 'Booking details',
                  icon: Icons.history_outlined,
                  activeIcon: Icons.history,
                  isSelected: activeTab == 'history',
                  isDark: isDark,
                ),
                _buildDrawerItem(
                  context: context,
                  id: 'billing',
                  title: 'Wallet',
                  subtitle: 'Transactions & saldo',
                  icon: Icons.account_balance_wallet_outlined,
                  activeIcon: Icons.account_balance_wallet,
                  isSelected: activeTab == 'billing',
                  isDark: isDark,
                ),
                _buildDrawerItem(
                  context: context,
                  id: 'profile',
                  title: 'Profile',
                  subtitle: 'Account settings',
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  isSelected: activeTab == 'profile',
                  isDark: isDark,
                ),
                _buildDrawerItem(
                  context: context,
                  id: 'switch_role',
                  title: 'Switch Role',
                  subtitle: 'Current: ${role.toUpperCase()}',
                  icon: Icons.swap_horiz,
                  activeIcon: Icons.swap_horiz,
                  isSelected: false,
                  isDark: isDark,
                ),

                // Dark Mode Switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF172128),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isDark ? Icons.nights_stay : Icons.light_mode_outlined,
                            color: AppColors.gold,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Toggle theme",
                                style: TextStyle(
                                  color: Color(0xFFBBCAC1),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (val) {
                            isDarkModeNotifier.value = val;
                          },
                          activeThumbColor: AppColors.gold,
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Divider(color: Colors.white10),
                ),

                // Logout Item
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _handleSignOut(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF172128),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Sign out of account",
                                  style: TextStyle(
                                    color: Color(0xFFBBCAC1),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required bool isDark,
  }) {
    final activeBgColor = AppColors.gold;
    final inactiveBgColor = const Color(0xFF172128);
    final iconColor = isSelected ? Colors.black : AppColors.gold;
    final textColor = isSelected ? AppColors.gold : Colors.white;
    final subtitleColor = isSelected ? AppColors.gold.withOpacity(0.7) : const Color(0xFFBBCAC1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          if (id == 'switch_role') {
            final prefs = await SharedPreferences.getInstance();
            final currentRole = prefs.getString('session_role') ?? 'client';
            final newRole = currentRole == 'client' ? 'expert' : 'client';
            await prefs.setString('session_role', newRole);
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                newRole == 'expert' ? '/expert_dashboard' : '/dashboard',
                (route) => false,
              );
            }
          } else {
            _changeTab(context, id);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? activeBgColor : inactiveBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
