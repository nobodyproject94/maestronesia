import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const MainLayout({
    super.key,
    required this.child,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSignOut,
  });

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
    return Container(
      decoration: isDark
          ? const BoxDecoration(color: Color(0xFF131D24))
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
        body: Row(
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
                          'dashboard',
                          'Explore',
                          Icons.explore_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          'history',
                          'History',
                          Icons.history,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          'billing',
                          'Wallet',
                          Icons.account_balance_wallet_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          'profile',
                          'Profile',
                          Icons.person_outline,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildSidebarItem(
                          'live_chat_list',
                          'Live Chat',
                          Icons.chat_bubble_outline,
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
                        onPressed: onSignOut,
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
    String id,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = activeTab == id;
    return InkWell(
      onTap: () => onTabChanged(id),
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

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return Container(
      decoration: isDark
          ? const BoxDecoration(color: Color(0xFF131D24))
          : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0B1528), Color(0xFF1E3A8A)],
              ),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: _buildMobileDrawer(context, isDark),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.gold),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surface
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                ),
                child: Icon(Icons.menu_book, color: AppColors.gold, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Maestro',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
              },
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BottomBar(
          theme: BottomBarThemeData(
            barDecoration: BoxDecoration(
              color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark ? AppColors.cardBorder : Colors.white.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          layout: BottomBarLayout(
            width: MediaQuery.of(context).size.width - 48,
            borderRadius: BorderRadius.circular(32),
            alignment: Alignment.bottomCenter,
            respectSafeArea: true,
          ),
          body: child,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFloatingNavItem(0, Icons.explore_outlined, Icons.explore, isDark),
                _buildFloatingNavItem(1, Icons.history, Icons.history_toggle_off, isDark),
                _buildFloatingNavItem(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, isDark),
                _buildFloatingNavItem(3, Icons.person_outline, Icons.person, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getTabIndex(String tab) {
    if (tab == 'history') return 1;
    if (tab == 'billing') return 2;
    if (tab == 'profile') return 3;
    return 0;
  }

  String _getTabName(int index) {
    if (index == 1) return 'history';
    if (index == 2) return 'billing';
    if (index == 3) return 'profile';
    return 'dashboard';
  }

  Widget _buildMobileDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: isDark
            ? const BoxDecoration(color: Color(0xFF131D24))
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0B1528), Color(0xFF1E3A8A)],
                ),
              ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop',
                      ),
                      backgroundColor: AppColors.gold.withOpacity(0.1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fajar Ramadhan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Client · Engineering',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(context, 'Explore', Icons.explore_outlined, 'dashboard'),
                    _buildDrawerItem(context, 'History', Icons.explore_outlined, 'history'), // explore_outlined as placeholder or similar
                    _buildDrawerItem(context, 'Wallet', Icons.account_balance_wallet_outlined, 'billing'),
                    _buildDrawerItem(context, 'Profile', Icons.person_outline, 'profile'),
                    _buildDrawerItem(context, 'Live Chat', Icons.chat_bubble_outline, 'live_chat_list'),
                  ],
                ),
              ),
              const Divider(color: Colors.white10),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        isDarkModeNotifier.value = !isDarkModeNotifier.value;
                      },
                      icon: Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onSignOut,
                      icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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

  Widget _buildDrawerItem(BuildContext context, String label, IconData icon, String tabId) {
    final isSelected = activeTab == tabId;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.gold : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.gold : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // close drawer
        onTabChanged(tabId);
      },
    );
  }

  Widget _buildFloatingNavItem(int index, IconData icon, IconData activeIcon, bool isDark) {
    final isSelected = _getTabIndex(activeTab) == index;
    return InkWell(
      onTap: () => onTabChanged(_getTabName(index)),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.gold.withOpacity(0.15) : AppColors.gold.withOpacity(0.2))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? AppColors.gold : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}
