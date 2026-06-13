import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import '../widgets/custom_snackbar.dart';

// =========================================================================
// PAYMENTSCREEN ADALAH STATEFULWIDGET YANG MENAMPILKAN HALAMAN CHECKOUT PEMBAYARAN
// UNTUK MENGONFIRMASI PEMESANAN SESI KONSULTASI DENGAN PAKAR YANG DIPILIH.
// =========================================================================
class PaymentScreen extends StatefulWidget {
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
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double _balance = 1240500.0;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = prefs.getDouble('wallet_balance') ?? 1240500.0;
    });
  }

  Future<void> _saveBalance(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('wallet_balance', value);
  }

  double _parsePrice(String priceStr) {
    final clean = priceStr.replaceAll('Rp', '').replaceAll(' ', '').replaceAll('k', '').trim();
    final parsed = double.tryParse(clean) ?? 0.0;
    if (priceStr.contains('k')) {
      return parsed * 1000.0;
    }
    return parsed;
  }

  String _formatCurrency(double amount) {
    final int value = amount.toInt();
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'dashboard',
          showAppBar: false,
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
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
                        onPressed: widget.onBack,
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.textSecondary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
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
                      color: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
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
                                    widget.expert.name,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.gold,
                                        size: 14,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
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
                                  widget.expert.price,
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
                        Divider(color: AppColors.dividerColor, height: 1),
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
                            color: isDark ? AppColors.gold.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.1),
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
                                      'BAL: RP ${_formatCurrency(_balance)}',
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
                              color: isDark ? const Color(0xFF172128).withValues(alpha: 0.5) : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
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
                                      color: AppColors.dividerColor,
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
                      color: isDark ? AppColors.gold.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
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
                      onPressed: () async {
                        final price = _parsePrice(widget.expert.price);
                        if (_balance >= price) {
                          final newBal = _balance - price;
                          await _saveBalance(newBal);
                          widget.onConfirm();
                        } else {
                           showCustomSnackBar(context, 'Insufficient balance! Please top up your wallet.', isError: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.gold : AppColors.gold.withValues(alpha: 0.15),
                        foregroundColor: isDark ? Colors.black : AppColors.gold,
                        side: BorderSide(color: AppColors.gold, width: isDark ? 0 : 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: isDark ? 0 : 8.0,
                        shadowColor: isDark
                            ? Colors.transparent
                            : AppColors.gold.withValues(alpha: 0.35),
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
      },
    );
  }
}
