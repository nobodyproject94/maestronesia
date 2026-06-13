import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';

// =========================================================================
// ONBOARDINGSCREEN ADALAH STATEFULWIDGET YANG BERFUNGSI SEBAGAI LAYAR PENYAMBUT UTAMA (ONBOARDING)
// DI MANA PENGGUNA DAPAT MEMAHAMI TUJUAN APLIKASI DAN MEMILIH PERAN (ROLE) SEBAGAI CLIENT ATAU EXPERT.
// =========================================================================
class OnboardingScreen extends StatefulWidget {
  final void Function(String role) onBegin;
  final void Function(String role) onSignIn;

  const OnboardingScreen({
    super.key,
    required this.onBegin,
    required this.onSignIn,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedRole = '';

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // VALUELISTENABLEBUILDER DIGUNAKAN UNTUK MENDENGARKAN PERUBAHAN STATUS MODE GELAP/TERANG SECARA DINAMIS.
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          // =========================================================================
          // MENGATUR WARNA LATAR BELAKANG SCAFFOLD MENYESUAIKAN TEMA AKTIF.
          // =========================================================================
          backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
          body: MaestronesiaBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    
                    // =========================================================================
                    // 1. AREA JUDUL & DESKRIPSI UTAMA
                    // =========================================================================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================================================
                        // AKSEN GARIS DEKORATIF WARNA EMAS KHAS MAESTRONESIA.
                        // =========================================================================
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // =========================================================================
                        // JUDUL SAMBUTAN UTAMA.
                        // =========================================================================
                        Text(
                          'Expertise,\nSimplified.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // =========================================================================
                        // PENJELASAN SINGKAT FITUR UTAMA APLIKASI.
                        // =========================================================================
                        Text(
                          'Connect with world-class experts for real-time guidance and professional consultation.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    // =========================================================================
                    // 2. PANEL PEMILIHAN PERAN (ROLE SELECTION)
                    // =========================================================================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECT YOUR ROLE',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // =========================================================================
                        // DUA BUAH KARTU PEMILIHAN PERAN BERDAMPINGAN.
                        // =========================================================================
                        Row(
                          children: [
                            Expanded(
                              child: _buildRoleCard(
                                roleName: 'client',
                                label: 'Client',
                                icon: Icons.person_outline,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRoleCard(
                                roleName: 'expert',
                                label: 'Expert',
                                icon: Icons.workspace_premium_outlined,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    
                    // =========================================================================
                    // 3. TOMBOL AKSI DI BAGIAN BAWAH HALAMAN
                    // =========================================================================
                    Column(
                      children: [
                        // =========================================================================
                        // MENAMPILKAN TOMBOL NONAKTIF ABU-ABU JIKA BELUM ADA PERAN YANG DIPILIH.
                        // =========================================================================
                        if (_selectedRole != 'client' && _selectedRole != 'expert')
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'BEGIN JOURNEY',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          )
                        // =========================================================================
                        // MENAMPILKAN TOMBOL EMAS AKTIF JIKA PERAN SUDAH BERHASIL DIPILIH.
                        // =========================================================================
                        else
                          MaestronesiaButton(
                            onPressed: () => widget.onBegin(_selectedRole),
                            isSelected: !isDark,
                            child: const Text(
                              'BEGIN JOURNEY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        // =========================================================================
                        // MENGARAHKAN KE LAYAR MASUK JIKA SUDAH TERDAFTAR SEBAGAI ANGGOTA.
                        // =========================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already a member? ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final role = _selectedRole.isEmpty ? 'client' : _selectedRole;
                                widget.onSignIn(role);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.gold,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.only(bottom: 2),
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MEMBANGUN WIDGET KARTU PEMILIHAN PERAN (CLIENT / EXPERT).
  // =========================================================================
  Widget _buildRoleCard({
    required String roleName,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedRole == roleName;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = roleName), // MEMICU PERUBAHAN PERAN KETIKA KARTU DIKLIK.
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), // DURASI TRANSISI VISUAL YANG HALUS SAAT BERUBAH STATE.
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          // =========================================================================
          // MEWARNAI KARTU SECARA DINAMIS BERDASARKAN STATUS PILIHAN DAN TEMA AKTIF.
          // =========================================================================
          color: isDark
              ? (isSelected ? AppColors.gold.withValues(alpha: 0.05) : AppColors.surface)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? (isSelected ? AppColors.gold : Colors.white.withValues(alpha: 0.05))
                : Colors.white.withValues(alpha: 0.05),
            width: isDark ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =========================================================================
                // IKON REPRESENTATIF PERAN (WARNA EMAS JIKA TERPILIH).
                // =========================================================================
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                // =========================================================================
                // NAMA PERAN.
                // =========================================================================
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // =========================================================================
            // TOMBOL STATUS SELEKSI MELINGKAR DI POJOK KANAN ATAS KARTU (RADIO BUTTON MOCK).
            // =========================================================================
            Positioned(
              top: 0,
              right: 12,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.gold, width: 2)
                      : Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                ),
                child: isSelected
                    ? Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
