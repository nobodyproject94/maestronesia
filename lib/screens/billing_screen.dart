import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';

// =========================================================================
// BILLINGSCREEN MERENDER HALAMAN TAGIHAN DAN E-WALLET/DOMPET DIGITAL USER.
// =========================================================================
class BillingScreen extends StatefulWidget {
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;
  final String name;
  final String role;

  const BillingScreen({
    super.key,
    required this.onTabChanged,
    required this.onSignOut,
    required this.name,
    required this.role,
  });

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  double _balance = 1240500.0;
  String _selectedPaymentMethod = 'wallet';

  final List<Map<String, String>> _cards = []; // Re-added so _showAddCardDialog compiles

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'wallet',
      'name': 'Maestro Wallet',
      'isLinked': true,
      'color': const Color(0xFFE6BC6A),
    },
    {
      'id': 'gopay',
      'name': 'gopay',
      'isLinked': false,
      'color': const Color(0xFF00AED6),
    },
    {
      'id': 'shopeepay',
      'name': 'ShopeePay',
      'isLinked': false,
      'color': const Color(0xFFEE4D2D),
    },
    {
      'id': 'ovo',
      'name': 'OVO',
      'isLinked': false,
      'color': const Color(0xFF4C3494),
    },
    {
      'id': 'dana',
      'name': 'DANA',
      'isLinked': false,
      'color': const Color(0xFF118EEA),
    },
    {
      'id': 'linkaja',
      'name': 'LinkAja',
      'isLinked': false,
      'color': const Color(0xFFE30A16),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = prefs.getDouble('wallet_balance') ?? 1240500.0;
    });
  }

  Future<void> _saveBalance(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('wallet_balance', value);
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

  void _showTopUpDialog(BuildContext context) {
    final amountController = TextEditingController();
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Top Up Wallet',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter amount to top up:',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.inputText),
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.hintText),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [50000, 100000, 200000, 500000].map((amt) {
                    return ChoiceChip(
                      label: Text('Rp ${_formatCurrency(amt.toDouble())}'),
                      selected: false,
                      labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 11),
                      backgroundColor: AppColors.cardBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (_) {
                        amountController.text = amt.toString();
                      },
                    );
                  }).toList(),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt > 0) {
                    setState(() {
                      _balance += amt;
                    });
                    _saveBalance(_balance);
                    Navigator.pop(context);
                    showCustomSnackBar(context, 'Rp ${_formatCurrency(amt)} successfully topped up!');
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
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text('Top Up'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final amountController = TextEditingController();
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Withdraw Funds',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter amount to withdraw:',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.inputText),
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.hintText),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt > 0) {
                    if (amt <= _balance) {
                      setState(() {
                        _balance -= amt;
                      });
                      _saveBalance(_balance);
                      Navigator.pop(context);
                      showCustomSnackBar(context, 'Rp ${_formatCurrency(amt)} successfully withdrawn!');
                    } else {
                      showCustomSnackBar(context, 'Insufficient balance!', isError: true);
                    }
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
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text('Withdraw'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCardDialog(BuildContext context) {
    final numberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Add Payment Method',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.inputText),
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.hintText),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryController,
                          style: TextStyle(color: AppColors.inputText),
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            hintStyle: TextStyle(color: AppColors.hintText),
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.hintText),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          style: TextStyle(color: AppColors.inputText),
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.hintText),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  final numText = numberController.text.trim();
                  final expText = expiryController.text.trim();
                  if (numText.isNotEmpty && expText.isNotEmpty) {
                    final last4 = numText.length >= 4 ? numText.substring(numText.length - 4) : numText;
                    setState(() {
                      _cards.add({
                        'type': numText.startsWith('4') ? 'VISA' : 'Mastercard',
                        'brand': numText.startsWith('4') ? 'VISA' : 'Mastercard',
                        'number': last4,
                        'expiry': expText,
                        'isPrimary': 'false'
                      });
                    });
                    Navigator.pop(context);
                    showCustomSnackBar(context, 'Card ending in $last4 added successfully!');
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
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text('Add Card'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
            backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
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
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Rp',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  _formatCurrency(_balance),
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
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
                                onPressed: () => _showTopUpDialog(context),
                                height: 52,
                                borderRadius: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.credit_card, size: 18, color: isDark ? Colors.black : Colors.white),
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
                                onPressed: () => _showWithdrawDialog(context),
                                height: 52,
                                borderRadius: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 18,
                                      color: isDark ? Colors.black : Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Withdraw',
                                      style: TextStyle(
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
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showCustomSnackBar(context, 'Delete non-primary cards by tapping the trash icon next to them.');
                        },
                        child: const Text(
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
                  // DAFTAR METODE PEMBAYARAN LOKAL E-WALLETS
                  // =========================================================================
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surface : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: _paymentMethods.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final method = entry.value;
                        final bool isSelected = _selectedPaymentMethod == method['id'];
                        final bool isWallet = method['id'] == 'wallet';

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (method['isLinked'] || isWallet) {
                                  setState(() {
                                    _selectedPaymentMethod = method['id'];
                                  });
                                } else {
                                  showCustomSnackBar(context, 'Silakan sambungkan ${method['name']} terlebih dahulu.');
                                }
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    // Logo Placeholder
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        isWallet ? 'MW' : method['name'],
                                        style: TextStyle(
                                          color: method['color'],
                                          fontWeight: FontWeight.w900,
                                          fontSize: isWallet ? 16 : 12,
                                          fontStyle: isWallet ? FontStyle.normal : FontStyle.italic,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isWallet ? 'Maestro Wallet' : method['name'],
                                            style: TextStyle(
                                              color: isDark ? Colors.white : AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: isWallet ? FontWeight.bold : FontWeight.w500,
                                            ),
                                          ),
                                          if (isWallet) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              'Saldo : Rp ${_formatCurrency(_balance)}',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (method['isLinked'] || isWallet) ...[
                                      // Radio Button untuk yang sudah linked
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected ? AppColors.gold : AppColors.textSecondary.withValues(alpha: 0.5),
                                            width: isSelected ? 6 : 1.5,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      // Tombol Sambungkan
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFE30A16)), // Red border like screenshot
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Sambungkan',
                                          style: TextStyle(
                                            color: Color(0xFFE30A16),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                            if (index < _paymentMethods.length - 1)
                              Divider(
                                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.1),
                                height: 1,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // =========================================================================
                  // TOMBOL UNTUK MENAMBAHKAN METODE PEMBAYARAN BARU
                  // =========================================================================
                  Container(
                    width: double.infinity,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.dividerColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _showAddCardDialog(context),
                      borderRadius: BorderRadius.circular(28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
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
        );
      },
    );
  }
}
