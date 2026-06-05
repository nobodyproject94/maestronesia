import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';

class ExpertDashboardScreen extends StatefulWidget {
  final VoidCallback onStartLiveSession;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const ExpertDashboardScreen({
    super.key,
    required this.onStartLiveSession,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'dashboard',
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // PERBAIKAN HEADER BANNER: Emas di Dark Mode, Transparan tipis di Light Mode
                Container(
                  color: isDark
                      ? AppColors.gold
                      : Colors.white.withOpacity(0.05),
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.book_outlined,
                                color: isDark ? Colors.black : AppColors.gold,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Maestronesia',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.black
                                      : AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.notifications_none,
                            color: isDark
                                ? Colors.black
                                : AppColors.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isOnline ? 'You are Online' : 'You are Offline',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.black
                                  : AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Switch(
                            value: _isOnline,
                            onChanged: (val) {
                              setState(() {
                                _isOnline = val;
                              });
                            },
                            activeThumbColor: isDark ? Colors.black : AppColors.gold,
                            activeTrackColor: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dashboard Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expert Dashboard',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Earnings Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL EARNINGS',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Rp 2.5M',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                Icon(
                                  Icons.book_outlined,
                                  color: Colors.white10,
                                  size: 48,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
