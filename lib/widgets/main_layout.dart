import 'package:flutter/material.dart';
import '../theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const MainLayout({
    Key? key,
    required this.child,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    if (isDesktop) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar Desktop
          Container(
            width: 260,
            color: AppColors.surface,
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
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Maestronesia',
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
                        id: 'dashboard',
                        label: 'Explore',
                        icon: Icons.explore_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildSidebarItem(
                        id: 'history',
                        label: 'History',
                        icon: Icons.history,
                      ),
                      const SizedBox(height: 8),
                      _buildSidebarItem(
                        id: 'billing',
                        label: 'Wallet',
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildSidebarItem(
                        id: 'profile',
                        label: 'Profile',
                        icon: Icons.person_outline,
                      ),
                    ],
                  ),
                ),

                // Sidebar Footer (Profile Info & Logout)
                const Divider(color: AppColors.cardBorder, height: 24),
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
                        children: const [
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
                IconButton(
                  onPressed: onSignOut,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  tooltip: 'Sign Out',
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = activeTab == id;
    return InkWell(
      onTap: () => onTabChanged(id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.menu_book,
                color: AppColors.gold,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Maestronesia',
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
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.cardBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _getTabIndex(activeTab),
          onTap: (index) {
            final tabName = _getTabName(index);
            onTabChanged(tabName);
          },
          backgroundColor: AppColors.surface.withOpacity(0.8),
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history_toggle_off),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _getTabIndex(String tab) {
    switch (tab) {
      case 'dashboard':
        return 0;
      case 'history':
        return 1;
      case 'billing':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'dashboard';
      case 1:
        return 'history';
      case 2:
        return 'billing';
      case 3:
        return 'profile';
      default:
        return 'dashboard';
    }
  }
}
