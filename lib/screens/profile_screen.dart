import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';

// =========================================================================
// PROFILESCREEN ADALAH STATEFULWIDGET YANG MENAMPILKAN DETAIL INFORMASI AKUN PENGGUNA AKTIF,
// SERTA MENYEDIAKAN MENU PENGATURAN SESI DAN STATUS ONLINE KHUSUS UNTUK PAKAR (EXPERT).
// =========================================================================
class ProfileScreen extends StatefulWidget {
  final String role; // PERAN PENGGUNA SAAT INI ('CLIENT' ATAU 'EXPERT').
  final String email; // EMAIL PENGGUNA YANG SEDANG MASUK.
  final String name; // NAMA LENGKAP PENGGUNA.
  final ValueChanged<String> onTabChanged; // CALLBACK NAVIGASI PERPINDAHAN TAB NAVIGASI UTAMA.
  final VoidCallback onSignOut; // CALLBACK KETIKA PENGGUNA MENEKAN TOMBOL KELUAR (SIGN OUT).

  const ProfileScreen({
    super.key,
    required this.role,
    required this.email,
    required this.name,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // =========================================================================
  // STATE UNTUK MELACAK APAKAH PAKAR (EXPERT) BERSEDIA MENERIMA PANGGILAN / KONSULTASI BARU.
  // =========================================================================
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // DIBUNGKUS MAINLAYOUT AGAR BOTTOM NAVIGATION BAR TERPADU TETAP AKTIF TERLIHAT.
    // =========================================================================
    return MainLayout(
      activeTab: 'profile',
      onTabChanged: widget.onTabChanged,
      onSignOut: widget.onSignOut,
      child: Scaffold(
        backgroundColor: Colors.transparent, // TRANSPARAN AGAR GRADIEN BACKGROUND DI BAWAHNYA TERLIHAT.
        body: SingleChildScrollView(
          // =========================================================================
          // BOUNCINGSCROLLPHYSICS MEMBERIKAN EFEK MEMANTUL (ELASTIC BOUNCE) KHAS IOS SAAT SCROLL.
          // =========================================================================
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          // =========================================================================
          // PENTING: PADDING BOTTOM 120.0 DISEMATKAN AGAR TOMBOL "SIGN OUT" PALING BAWAH TIDAK TERHALANG OLEH BOTTOM NAVIGATION BAR.
          // =========================================================================
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================================
              // 1. KARTU PROFIL UTAMA (MAIN PROFILE CARD)
              // =========================================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    // =========================================================================
                    // STACK FOTO PROFIL BUNDAR DENGAN IKON RODA GIGI PENGATURAN DI KANAN BAWAH.
                    // =========================================================================
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 4),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // =========================================================================
                    // NAMA PENGGUNA.
                    // =========================================================================
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // =========================================================================
                    // EMAIL PENGGUNA.
                    // =========================================================================
                    Text(
                      widget.email,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // =========================================================================
                    // LABEL DESKRIPSI PERAN (ROLE).
                    // =========================================================================
                    Text(
                      widget.role == 'expert'
                          ? 'Mechanical Engineering Expert'
                          : 'Mechanical Engineering Client',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // =========================================================================
                    // TANDA BADGE LEVEL & TIER PENGGUNA.
                    // =========================================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'LEVEL 4',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'CLIENT TIER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // =========================================================================
                    // TOMBOL GARIS TEPI UNTUK MELIHAT PROFIL PUBLIK.
                    // =========================================================================
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.gold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'View Public Profile',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // =========================================================================
              // 2. STATUS KEBERADAAN PAKAR (AVAILABILITY TOGGLE) - HANYA MUNCUL JIKA ROLE = 'EXPERT'
              // =========================================================================
              if (widget.role == 'expert') ...[
                Text(
                  'EXPERT STATUS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isOnline
                          ? AppColors.gold.withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      // =========================================================================
                      // INDIKATOR BULAT HIJAU/ABU-ABU MELAMBANGKAN ONLINE/OFFLINE.
                      // =========================================================================
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _isOnline
                              ? AppColors.gold
                              : AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOnline
                                  ? 'Accepting Requests'
                                  : 'Currently Offline',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isOnline
                                  ? 'Available for live sessions'
                                  : 'Go online to receive requests',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // =========================================================================
                      // SWITCH TOGGLE UNTUK MENGAKTIFKAN/NONAKTIFKAN STATUS ONLINE PAKAR.
                      // =========================================================================
                      Switch(
                        value: _isOnline,
                        onChanged: (val) {
                          setState(() {
                            _isOnline = val;
                          });
                        },
                        activeThumbColor: AppColors.gold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // =========================================================================
              // 3. MENU AKUN (ACCOUNT SETTINGS SECTION)
              // =========================================================================
              Text(
                'ACCOUNT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    _buildAccountItem(
                      icon: Icons.person_outline,
                      title: 'Settings',
                      subtitle: 'Personal info, login, security',
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildAccountItem(
                      icon: Icons.credit_card,
                      title: 'Payments',
                      subtitle: 'Cards, billing history',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // =========================================================================
              // 4. TOMBOL KELUAR (SIGN OUT) WARNA MERAH MENCOLOK
              // =========================================================================
              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: widget.onSignOut,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MENYUSUN ITEM BARIS MENU PENGATURAN AKUN.
  // =========================================================================
  Widget _buildAccountItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () {}, // AKSI MOCK MENU ITEM.
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
