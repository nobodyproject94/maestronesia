import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import '../theme.dart';

// =========================================================================
// MAINLAYOUT ADALAH KERANGKA TATA LETAK UTAMA (STATELESS) APLIKASI.
// WIDGET INI MENYEDIAKAN STRUKTUR NAVIGASI YANG ADAPTIF: SIDEBAR UNTUK DESKTOP (LEBAR > 768PX)
// DAN APPBAR + BOTTOMNAVIGATIONBAR (MELAYANG) + NAVIGATION DRAWER UNTUK PERANGKAT MOBILE.
// =========================================================================
class MainLayout extends StatelessWidget {
  final Widget child; // WIDGET KONTEN UTAMA DARI SCREEN YANG AKTIF.
  final String activeTab; // NAMA TAB/LAYAR YANG SEDANG AKTIF SAAT INI.
  final ValueChanged<String> onTabChanged; // CALLBACK SAAT TAB NAVIGASI DIKLIK/DIUBAH.
  final VoidCallback onSignOut; // CALLBACK KETIKA USER MENEKAN TOMBOL LOGOUT.
  final bool showBottomBar; // MENENTUKAN APAKAH MOBILE FLOATING BOTTOM BAR PERLU DITAMPILKAN.
  final bool isOriginalExpert; // MENUNJUKKAN APAKAH PERAN ASLI USER ADALAH EXPERT.
  final VoidCallback? onSwitchRole; // CALLBACK PENGALIHAN PERAN SECARA DINAMIS.
  final String? currentRole; // PERAN AKTIF USER AKTIF ('CLIENT' ATAU 'EXPERT').

  const MainLayout({
    super.key,
    required this.child,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSignOut,
    this.showBottomBar = true,
    this.isOriginalExpert = false,
    this.onSwitchRole,
    this.currentRole,
  });

  // =========================================================================
  // MENDAPATKAN JUDUL LAYAR SECARA DINAMIS BERDASARKAN TAB AKTIF DAN PERAN AKTIF PENGGUNA.
  // =========================================================================
  String _getScreenTitle() {
    switch (activeTab) {
      case 'dashboard':
        return currentRole == 'expert' ? 'Dashboard' : 'Explore';
      case 'history':
        return 'History';
      case 'billing':
        return 'Wallet';
      case 'profile':
        return 'Profile';
      case 'live_chat_list':
      case 'live_chat':
        return 'Live Chat';
      default:
        return 'Maestro';
    }
  }

  // =========================================================================
  // MENDAPATKAN IKON LAYAR SECARA DINAMIS BERDASARKAN TAB AKTIF DAN PERAN AKTIF PENGGUNA.
  // =========================================================================
  IconData _getScreenIcon() {
    switch (activeTab) {
      case 'dashboard':
        return currentRole == 'expert' ? Icons.dashboard_outlined : Icons.explore_outlined;
      case 'history':
        return Icons.history;
      case 'billing':
        return Icons.account_balance_wallet_outlined;
      case 'profile':
        return Icons.person_outline;
      case 'live_chat_list':
      case 'live_chat':
        return Icons.chat_bubble_outline;
      default:
        return Icons.menu_book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768; // MENDETEKSI ORIENTASI DESKTOP BERDASARKAN LEBAR VIEWPORT.

    // =========================================================================
    // MEMANTAU STATUS ISDARKMODENOTIFIER UNTUK MEMPERBARUI DEKORASI GRADIEN/WARNA LATAR BELAKANG LAYOUT SECARA REAL-TIME.
    // =========================================================================
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

  // =========================================================================
  // MEMBANGUN TATA LETAK HALAMAN UNTUK TAMPILAN DESKTOP (SIDEBAR MENU DI KIRI DAN KONTEN UTAMA DI KANAN).
  // =========================================================================
  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return Container(
      decoration: isDark
          ? const BoxDecoration(color: Color(0xFF131D24))
          : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1528), // NAVY GELAP DI BAGIAN ATAS.
                  Color(0xFF1E3A8A), // BIRU ELEKTRIK DI BAGIAN BAWAH.
                ],
              ),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            // =========================================================================
            // SIDEBAR MENU UNTUK LAYAR LEBAR (DESKTOP).
            // =========================================================================
            Container(
              width: 260,
              color: isDark ? AppColors.surface : Colors.transparent, // TRANSPARAN JIKA LIGHT MODE AGAR GRADIEN DI BELAKANG TERLIHAT.
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // JUDUL/LOGO MAESTRO.
                  // =========================================================================
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

                  // =========================================================================
                  // LIST ITEM NAVIGASI UTAMA.
                  // =========================================================================
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
                        if (isOriginalExpert && onSwitchRole != null) ...[
                          const SizedBox(height: 16),
                          // =========================================================================
                          // TOMBOL KHUSUS UNTUK MENGALIHKAN PERAN DI DALAM SIDEBAR DESKTOP
                          // =========================================================================
                          InkWell(
                            onTap: onSwitchRole,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.swap_horiz,
                                    color: AppColors.gold,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      currentRole == 'expert' ? 'Switch to Client' : 'Switch to Expert',
                                      style: const TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // =========================================================================
                  // GARIS PEMBATAS DAN INFO USER DI BAGIAN BAWAH SIDEBAR.
                  // =========================================================================
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
                  // =========================================================================
                  // TOMBOL GANTI TEMA (DARK/LIGHT) DAN TOMBOL LOGOUT DI FOOTER SIDEBAR.
                  // =========================================================================
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
            // =========================================================================
            // PANEL KONTEN UTAMA.
            // =========================================================================
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // MEMBUAT ITEM NAVIGASI LIST TILE KUSTOM UNTUK SIDEBAR DESKTOP.
  // =========================================================================
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
          // =========================================================================
          // KAPSUL BACKGROUND HANYA AKTIF PENUH PADA MODE GELAP, MODE TERANG DIBUAT TRANSPARAN.
          // =========================================================================
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
            // =========================================================================
            // LINGKARAN KECIL SEBAGAI PENANDA AKTIF JIKA DALAM LIGHT MODE.
            // =========================================================================
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

  // =========================================================================
  // MEMBANGUN TATA LETAK HALAMAN UNTUK TAMPILAN MOBILE (APPBAR ATAS + FLOATING BOTTOM NAVIGATION BAR).
  // =========================================================================
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
        drawer: _buildMobileDrawer(context, isDark), // DRAWER MENU SAMPING KIRI UNTUK MOBILE.
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
                child: Icon(_getScreenIcon(), color: AppColors.gold, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                _getScreenTitle(),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            // =========================================================================
            // PINTASAN TOMBOL TOGGLE TEMA DI POJOK KANAN ATAS.
            // =========================================================================
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
        // =========================================================================
        // BOTTOMBAR MEMBUNGKUS LAYAR MOBILE DAN MEMUNCULKAN BOTTOM NAVIGATION BAR MELAYANG (FLOATING).
        // =========================================================================
        body: showBottomBar
            ? BottomBar(
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
                      // =========================================================================
                      // ITEM-ITEM NAVIGASI BAR BAWAH.
                      // =========================================================================
                      _buildFloatingNavItem(0, Icons.explore_outlined, Icons.explore, isDark),
                      _buildFloatingNavItem(1, Icons.history, Icons.history_toggle_off, isDark),
                      _buildFloatingNavItem(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, isDark),
                      _buildFloatingNavItem(3, Icons.person_outline, Icons.person, isDark),
                    ],
                  ),
                ),
              )
            : child,
      ),
    );
  }

  // =========================================================================
  // MENGUBAH PARAMETER NAMA TAB STRING MENJADI INDEKS INTEGER TAB BOTTOM BAR.
  // =========================================================================
  int _getTabIndex(String tab) {
    if (tab == 'history') return 1;
    if (tab == 'billing') return 2;
    if (tab == 'profile') return 3;
    return 0;
  }

  // =========================================================================
  // MENGONVERSI INDEKS INTEGER TAB BOTTOM BAR KEMBALI KE NAMA TAB STRING ROUTING.
  // =========================================================================
  String _getTabName(int index) {
    if (index == 1) return 'history';
    if (index == 2) return 'billing';
    if (index == 3) return 'profile';
    return 'dashboard';
  }

  // =========================================================================
  // MEMBANGUN NAVIGASI MENU SAMPING (DRAWER) PADA TAMPILAN MOBILE.
  // =========================================================================
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
              // =========================================================================
              // HEADER DRAWER DENGAN INFO PROFILE PENGGUNA.
              // =========================================================================
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
              // =========================================================================
              // MENU LINK NAVIGASI DI DALAM DRAWER.
              // =========================================================================
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(context, 'Explore', Icons.explore_outlined, 'dashboard'),
                    _buildDrawerItem(context, 'History', Icons.history, 'history'),
                    _buildDrawerItem(context, 'Wallet', Icons.account_balance_wallet_outlined, 'billing'),
                    _buildDrawerItem(context, 'Profile', Icons.person_outline, 'profile'),
                    _buildDrawerItem(context, 'Live Chat', Icons.chat_bubble_outline, 'live_chat_list'),
                    if (isOriginalExpert && onSwitchRole != null) ...[
                      const Divider(color: Colors.white10),
                      // =========================================================================
                      // LISTTILE KHUSUS UNTUK MENGALIHKAN PERAN DI DALAM MENU DRAWER MOBILE
                      // =========================================================================
                      ListTile(
                        leading: const Icon(
                          Icons.swap_horiz,
                          color: AppColors.gold,
                        ),
                        title: Text(
                          currentRole == 'expert' ? 'Switch to Client Mode' : 'Switch to Expert Mode',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // MENUTUP DRAWER SEBELUM BERPINDAH
                          onSwitchRole!(); // MEMICU FUNGSI SWAP ROLE
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(color: Colors.white10),
              // =========================================================================
              // FOOTER DRAWER DENGAN OPSI GANTI TEMA & LOGOUT.
              // =========================================================================
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

  // =========================================================================
  // MEMBUAT LISTTILE KUSTOM UNTUK DITAMPILKAN DI MENU DRAWER MOBILE.
  // =========================================================================
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
        Navigator.pop(context); // MENUTUP DRAWER TERLEBIH DAHULU SETELAH DIKLIK.
        onTabChanged(tabId); // MENGUBAH TAB AKTIF.
      },
    );
  }

  // =========================================================================
  // MEMBUAT ITEM NAVIGASI YANG MELAYANG (FLOATING) DI BOTTOM BAR MOBILE DENGAN ANIMASI PERUBAHAN STATE WARNA.
  // =========================================================================
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
