import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// MAESTRONESIADRAWER ADALAH WIDGET DRAWER UTAMA (STATELESSWIDGET)
// YANG MENYEDIAKAN MENU NAVIGASI SAMPING KIRI KHUSUS UNTUK TAMPILAN MOBILE.
// WIDGET INI MEMUNGKINKAN PENGGUNA BERPINDAH ANTAR LAYAR DAN MELAKUKAN LOGOUT.
// =========================================================================
class MaestronesiaDrawer extends StatelessWidget {
  final String activeTab; // NAMA TAB ATAU HALAMAN AKTIF YANG SEDANG DIBUKA.
  final ValueChanged<String> onTabChanged; // FUNGSI CALLBACK UNTUK PINDAH HALAMAN SAAT ITEM DIKLIK.
  final VoidCallback onSignOut; // FUNGSI CALLBACK UNTUK LOGOUT PENGGUNA.

  const MaestronesiaDrawer({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // MEMANTAU STATUS MODE TEMA SECARA REAL-TIME DARI VALUENOTIFIER GLOBAL.
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Drawer(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: isDark
                ? const BoxDecoration(color: Color(0xFF131D24))
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0B1528), // GRADIEN BIRU GELAP ATAS.
                        Color(0xFF1E3A8A), // GRADIEN BIRU TERANG BAWAH.
                      ],
                    ),
                  ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // HEADER DRAWER: MENAMPILKAN FOTO PROFIL, NAMA LENGKAP, DAN PERAN PENGGUNA.
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
                          backgroundColor: AppColors.gold.withValues(alpha: 0.1),
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
                  // MENU LINK NAVIGASI UTAMA DI DALAM LISTVIEW AGAR TAMPILAN DAPAT DI-SCROLL JIKA BERLEBIH.
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
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10),

                  // =========================================================================
                  // FOOTER DRAWER: BERISI TOMBOL TOGGLE TEMA DAN TOMBOL LOGOUT (SIGN OUT).
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
      },
    );
  }

  // =========================================================================
  // FUNGSI HELPER UNTUK MEMBUAT LISTTILE ITEM MENU SECARA KONSISTEN DENGAN TEMA WARNA AKTIF.
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
        Navigator.pop(context); // MENUTUP DRAWER SECARA OTOMATIS SETELAH DIPILIH.
        onTabChanged(tabId); // MEMICU CALLBACK UNTUK BERPINDAH HALAMAN.
      },
    );
  }
}
