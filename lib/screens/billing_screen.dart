import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';
import '../widgets/custom_button.dart';

// =========================================================================
// BILLINGSCREEN MERENDER HALAMAN TAGIHAN DAN E-WALLET/DOMPET DIGITAL USER.
// =========================================================================
class BillingScreen extends StatelessWidget {
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const BillingScreen({
    super.key,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // MEMBUNGKUS HALAMAN DENGAN LAYOUT UTAMA (MAINLAYOUT) AGAR SERAGAM DENGAN NAVIGASI UTAMA.
    // =========================================================================
    return MainLayout(
      activeTab: 'billing',
      onTabChanged: onTabChanged,
      onSignOut: onSignOut,
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // MENGGUNAKAN BACKGROUND GRADIEN DARI MAINLAYOUT.
        body: SingleChildScrollView(
          // =========================================================================
          // MENAMBAHKAN SCROLL PHYSICS BOUNCING AGAR NYAMAN DIGULIR (KHUSUSNYA UNTUK IOS).
          // =========================================================================
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: 120.0,
          ), // PADDING BAWAH DISESUAIKAN AGAR TIDAK TERTUTUP BOTTOM BAR MOBILE.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Billing & Wallet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // =========================================================================
              // KARTU SALDO E-WALLET
              // =========================================================================
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withOpacity(0.15),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABLE BALANCE',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // =========================================================================
                    // JUMLAH SALDO
                    // =========================================================================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rp',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '1,300,400,500,200',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: AppColors.gold,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Securely Encrypted',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // =========================================================================
                    // TOMBOL AKSI E-WALLET (TOP UP DAN WITHDRAW)
                    // =========================================================================
                    Row(
                      children: [
                        Expanded(
                          child: MaestronesiaButton(
                            onPressed:
                                () {}, // CALLBACK AKSI TOP UP SALDO (SIMULASI).
                            height: 52,
                            borderRadius: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.credit_card, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Top Up',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MaestronesiaButton(
                            onPressed:
                                () {}, // CALLBACK AKSI TARIK TUNAI SALDO (SIMULASI).
                            height: 52,
                            borderRadius: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 18,
                                  color: AppColors.gold,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // =========================================================================
              // HEADER METODE PEMBAYARAN TERDAFTAR
              // =========================================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Methods',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // =========================================================================
              // KARTU METODE PEMBAYARAN MASTERCARD UTAMA
              // =========================================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF374151), Color(0xFF4B5563)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'MASTER CARD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mastercard •••• 6666',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Expires 12/90',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // =========================================================================
                    // PENANDA KARTU UTAMA (PRIMARY)
                    // =========================================================================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'PRIMARY',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // =========================================================================
              // TOMBOL PUTUS-PUTUS UNTUK MENAMBAHKAN METODE PEMBAYARAN BARU
              // =========================================================================
              Container(
                width: double.infinity,
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white10,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  onTap: () {}, // CALLBACK TAMBAH KARTU BARU (SIMULASI).
                  borderRadius: BorderRadius.circular(28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, color: AppColors.textSecondary),
                      SizedBox(width: 10),
                      Text(
                        'Add New Payment Method',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
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
}
