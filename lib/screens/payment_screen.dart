import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import 'payment_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databases/database_helper.dart';

class PaymentScreen extends StatelessWidget {
  final Expert expert;
  final int day;
  final String time;

  const PaymentScreen({
    super.key,
    required this.expert,
    required this.day,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'dashboard',
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
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

                  // Checkout Summary Card
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
                        // Expert summary row
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
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.gold,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
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

                        // Payment method selector
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

                        // Wallet method (active)
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

                        // Other method (disabled mock)
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

                  // Guarantee Box
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

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        
                        final prefs = await SharedPreferences.getInstance();
                        final email = prefs.getString('session_email') ?? 'client@gmail.com';
                        
                        await DatabaseHelper.instance.createBooking({
                          'user_email': email,
                          'expert_id': expert.id,
                          'expert_name': expert.name,
                          'topic': expert.expertise,
                          'date': 'June $day, 2026',
                          'time': time,
                          'status': 'Upcoming',
                          'price': expert.price,
                          'notes': '',
                        });
                        
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentSuccessScreen(
                                expert: expert,
                                selectedDay: day,
                                selectedTime: time,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.gold : Colors.white.withOpacity(0.12),
                        foregroundColor: isDark ? Colors.black : AppColors.gold,
                        side: isDark ? null : const BorderSide(color: AppColors.gold, width: 2),
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
