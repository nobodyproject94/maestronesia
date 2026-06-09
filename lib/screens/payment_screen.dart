import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';

// =========================================================================
// PAYMENTSCREEN ADALAH STATELESSWIDGET YANG MENAMPILKAN HALAMAN CHECKOUT PEMBAYARAN
// UNTUK MENGONFIRMASI PEMESANAN SESI KONSULTASI DENGAN PAKAR YANG DIPILIH.
// =========================================================================
class PaymentScreen extends StatelessWidget {
  final Expert expert; // OBJEK DETAIL DATA PAKAR YANG AKAN DIPESAN DAN DIBAYAR JASANYA.
  final VoidCallback onBack; // CALLBACK KETIKA PENGGUNA MEMBATALKAN CHECKOUT DAN KEMBALI KE LAYAR SEBELUMNYA.
  final VoidCallback onConfirm; // CALLBACK SAAT PENGGUNA MENYETUJUI TRANSAKSI DAN MENEKAN TOMBOL KONFIRMASI.
  final ValueChanged<String> onTabChanged; // CALLBACK NAVIGASI PERPINDAHAN TAB LAYOUT UTAMA.
  final VoidCallback onSignOut; // CALLBACK KETIKA PENGGUNA KELUAR APLIKASI.

  const PaymentScreen({
    super.key,
    required this.expert,
    required this.onBack,
    required this.onConfirm,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // VALUELISTENABLEBUILDER MEMANTAU PERUBAHAN STATUS MODE GELAP/TERANG.
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        // =========================================================================
        // HALAMAN CHECKOUT DIBUNGKUS MAINLAYOUT AGAR BOTTOM NAVIGATION BAR TERPADU TETAP DAPAT DIAKSES.
        // =========================================================================
        return MainLayout(
          activeTab: 'dashboard',
          onTabChanged: onTabChanged,
          onSignOut: onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              // =========================================================================
              // BOUNCINGSCROLLPHYSICS MEMBERIKAN ANIMASI MEMANTUL SAAT DAFTAR CHECKOUT DITARIK MELEWATI BATAS SCROLL.
              // =========================================================================
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              // =========================================================================
              // PENTING: MENAMBAHKAN BOTTOM PADDING SEBESAR 120.0 AGAR TOMBOL "CONFIRM & PAY" DI BAWAH
              // TIDAK TERTUTUP ATAU TERHALANGI OLEH BOTTOM NAVIGATION BAR MILIK MAINLAYOUT.
              // =========================================================================
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 120.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // 1. HEADER BAR: TOMBOL KEMBALI + JUDUL HALAMAN
                  // =========================================================================
                  Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.textSecondary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white.withOpacity(0.05)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Checkout',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // 2. KARTU RINGKASAN PEMBAYARAN (CHECKOUT SUMMARY CARD)
                  // =========================================================================
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================================================
                        // DETAIL NAMA PAKAR DAN HARGA PEMESANAN.
                        // =========================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPERT SERVICE',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    expert.name,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppColors.gold,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Verified Expert',
                                        style: TextStyle(
                                          color: AppColors.gold,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  expert.price,
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Inc. Fees',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 24),

                        // =========================================================================
                        // BAGIAN METODE PEMBAYARAN AKTIF YANG DIPILIH.
                        // =========================================================================
                        const Text(
                          'PAYMENT METHOD',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // =========================================================================
                        // METODE: MAESTRONESIA WALLET (PILIHAN AKTIF DEFAULT)
                        // =========================================================================
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.gold.withOpacity(0.05) : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Maestronesia Wallet',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'BAL: RP 1,240,500',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // =========================================================================
                              // BULATAN RADIO BUTTON AKTIF WARNA EMAS.
                              // =========================================================================
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.gold, width: 6),
                                  color: isDark ? const Color(0xFF131D24) : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // =========================================================================
                        // METODE: TAMBAH BARU (MOCK DINONAKTIFKAN / DISAMARKAN TRANSPARANSINYA)
                        // =========================================================================
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF172128).withOpacity(0.5) : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.credit_card,
                                    color: AppColors.textSecondary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Add New Method',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white10,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // 3. GUARANTEE BOX: KOTAK JAMINAN KEAMANAN DANA
                  // =========================================================================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gold.withOpacity(0.05) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.gold, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Funds are held securely and only released after your session is marked as successful.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // 4. TOMBOL UTAMA KONFIRMASI & BAYAR
                  // =========================================================================
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.12),
                        foregroundColor: AppColors.gold,
                        side: const BorderSide(color: AppColors.gold, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm & Pay',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
