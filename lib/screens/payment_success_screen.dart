import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/custom_button.dart';

// =========================================================================
// PAYMENTSUCCESSSCREEN ADALAH STATELESSWIDGET YANG MENAMPILKAN LAYAR KONFIRMASI SUKSES
// SETELAH PENGGUNA BERHASIL MENYELESAIKAN PEMBAYARAN SESI PEMESANAN KONSULTASI PAKAR.
// =========================================================================
class PaymentSuccessScreen extends StatelessWidget {
  final Expert expert; // OBJEK DATA PAKAR YANG BERHASIL DIPESAN.
  final int selectedDay; // HARI/TANGGAL PELAKSANAAN KONSULTASI TERPILIH.
  final String selectedTime; // WAKTU/JAM PELAKSANAAN KONSULTASI TERPILIH.
  final VoidCallback
  onReturn; // CALLBACK UNTUK KEMBALI KE HALAMAN DASHBOARD UTAMA.
  final VoidCallback
  onViewSessions; // CALLBACK UNTUK MENGARAHKAN PENGGUNA KE HALAMAN RIWAYAT SESI.

  const PaymentSuccessScreen({
    super.key,
    required this.expert,
    required this.selectedDay,
    required this.selectedTime,
    required this.onReturn,
    required this.onViewSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent, // TRANSPARAN AGAR GRADIEN BACKGROUND DI BAWAHNYA TERLIHAT.
      body: MaestronesiaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // =========================================================================
                // 1. IKON CENTANG SUKSES BERPENDAR (SUCCESS ICON WITH GLOW EFFECT)
                // =========================================================================
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    // 1. Warna dasar lingkaran dibuat emas transparan bening (10% opacity)
                    color: const Color(0xFFE6BC6A).withOpacity(0.1),
                    shape: BoxShape.circle,
                    // 2. Tambahkan border emas menyala sebagai pembatas objek
                    border: Border.all(
                      color: const Color(0xFFE6BC6A).withOpacity(0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // 3. Naikkan opacity shadow dan blurRadius agar pendaran cahayanya luas
                        color: const Color(0xFFE6BC6A).withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons
                        .check, // Ubah ke Icons.check biasa agar tidak menyisakan bulatan hitam
                    color: Color(
                      0xFFE6BC6A,
                    ), // Centang emas solid agar kontras menembus kaca
                    size: 56,
                  ),
                ),
                const SizedBox(height: 40),

                // =========================================================================
                // 2. JUDUL HALAMAN DAN SUBJUDUL KUSTOM
                // =========================================================================
                Text(
                  'Payment Successful',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // =========================================================================
                // MENGGUNAKAN RICHTEXT UNTUK MEMBERIKAN AKSEN WARNA BERBEDA PADA NAMA PAKAR DI DALAM TEKS.
                // =========================================================================
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Your consultation with '),
                      TextSpan(
                        text: expert.name,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' has been scheduled.'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // =========================================================================
                // 3. KARTU RINGKASAN TANDA TERIMA (SUMMARY RECEIPT CARD)
                // =========================================================================
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      // =========================================================================
                      // BARIS TANGGAL SESI KONSULTASI.
                      // =========================================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DATE',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'Sep $selectedDay, 2024',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 16),
                      // =========================================================================
                      // BARIS WAKTU SESI KONSULTASI.
                      // =========================================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TIME',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            selectedTime,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 16),
                      // =========================================================================
                      // BARIS NAMA PAKAR YANG DIPESAN.
                      // =========================================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EXPERT',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            expert.name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // =========================================================================
                // 4. TOMBOL UTAMA KEMBALI KE DASHBOARD
                // =========================================================================
                MaestronesiaButton(
                  onPressed: onReturn,
                  child: const Text(
                    'RETURN TO DASHBOARD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // =========================================================================
                // 5. TOMBOL SEKUNDER TEKS UNTUK MELIHAT LIST PEMESANAN SESI
                // =========================================================================
                GestureDetector(
                  onTap: onViewSessions,
                  child: Text(
                    'VIEW MY SESSIONS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
