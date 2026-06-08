import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Menyimpan role yang dipilih pengguna (default: 'client')
  String selectedRole = 'client';

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan tema (Gelap/Terang) secara real-time tanpa rebuild seluruh screen
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          // Mengubah warna latar belakang secara kondisional berdasarkan mode tema
          backgroundColor: isDark
              ? const Color(0xFF131D24)
              : Colors.transparent,
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
                    const Spacer(), // Memberikan ruang kosong fleksibel (mendorong konten ke tengah/bawah)
                    // ================= TITLE AREA =================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Garis dekoratif kecil berwarna emas
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Expertise,\nSimplified.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height:
                                1.1, // Mengatur jarak antar baris teks (line-height)
                            letterSpacing: -1.0, // Merapatkan jarak antar huruf
                          ),
                        ),
                        const SizedBox(height: 16),
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

                    // ================= ROLE SELECTION AREA =================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECT YOUR ROLE',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing:
                                2.0, // Meregangkan jarak huruf untuk gaya UPPERCASE
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Expanded memastikan kedua kartu role membagi ruang horizontal secara adil (50:50)
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

                    // ================= ACTION BUTTONS AREA =================
                    Column(
                      children: [
                        // Validasi: Jika status selectedRole tidak valid (bukan client/expert), tampilkan tombol dinonaktifkan
                        if (selectedRole != 'client' &&
                            selectedRole != 'expert')
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'BEGIN JOURNEY',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          )
                        else
                          // Tombol aktif jika role valid
                          MaestronesiaButton(
                            onPressed: () {
                              HapticFeedback.lightImpact(); // Memberikan efek getar ringan saat ditekan
                              Navigator.pushNamed(
                                context,
                                '/signup',
                                arguments:
                                    selectedRole, // Mengirim data role yang dipilih ke halaman signup
                              );
                            },
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

                        // Teks & Tombol Sign In bawah
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
                                HapticFeedback.lightImpact();
                                Navigator.pushNamed(
                                  context,
                                  '/login',
                                  arguments: selectedRole,
                                );
                              },
                              child: Container(
                                // Membuat efek border bawah manual sebagai pengganti underline teks biasa
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

  // ================= KUSTOM WIDGET: KARTU PILIHAN ROLE =================
  Widget _buildRoleCard({
    required String roleName,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    // Mengecek apakah kartu ini adalah role yang sedang aktif/dipilih
    final isSelected = selectedRole == roleName;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Memperbarui status role yang dipilih dan memicu rebuild UI pada bagian ini
        setState(() {
          selectedRole = roleName;
        });
      },
      // AnimatedContainer membuat transisi warna/border halus saat kartu dipilih (durasi 250ms)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          // Warna background berubah smooth tergantung status 'isSelected' dan mode tema
          color: isDark
              ? (isSelected
                    ? AppColors.gold.withOpacity(0.05)
                    : AppColors.surface)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? (isSelected ? AppColors.gold : Colors.white.withOpacity(0.05))
                : Colors.white.withOpacity(0.05),
            width: isDark
                ? 2.0
                : 1.0, // Border lebih tebal jika dipilih pada mode gelap
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Konten Utama: Ikon dan Teks Label Role
            Column(
              mainAxisSize: MainAxisSize
                  .min, // Sesuai ukuran konten, tidak memakan ruang vertikal penuh
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? AppColors.gold
                      : AppColors
                            .textSecondary, // Warna ikon berubah jika dipilih
                ),
                const SizedBox(height: 12),
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

            // Komponen Radio Button Kustom (Lingkaran kecil di pojok kanan atas kartu)
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
                      : Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                ),
                // Jika terpilih, tampilkan titik bulat emas di dalam lingkaran
                child: isSelected
                    ? Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null, // Kosong jika tidak terpilih
              ),
            ),
          ],
        ),
      ),
    );
  }
}
