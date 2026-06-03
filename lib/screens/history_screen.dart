import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';

class HistoryScreen extends StatefulWidget {
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const HistoryScreen({
    Key? key,
    required this.onTabChanged,
    required this.onSignOut,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filters = ['All Sessions', 'Completed', 'Upcoming', 'Cancelled'];
  int _activeFilterIndex = 0;

  final List<Map<String, dynamic>> _historyItems = [
    {
      'expert': 'Prof. Dr. Hermanto',
      'topic': 'Thermal Dynamics',
      'date': 'May 10, 2024',
      'status': 'Completed',
      'price': 'Rp 150,000',
      'rating': 5.0,
    },
    {
      'expert': 'Dr. Sarah Amelia',
      'topic': 'Algorithm Review',
      'date': 'May 05, 2024',
      'status': 'Completed',
      'price': 'Rp 120,000',
      'rating': 4.8,
    },
    {
      'expert': 'Ir. Ahmad Fauzi',
      'topic': 'Structure Analysis',
      'date': 'Apr 28, 2024',
      'status': 'Cancelled',
      'price': 'Refunded',
      'rating': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activeTab: 'history',
      onTabChanged: widget.onTabChanged,
      onSignOut: widget.onSignOut,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Session History',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: AppColors.textSecondary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filters horizontal list
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final active = index == _activeFilterIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activeFilterIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? AppColors.gold : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? AppColors.gold : Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: active ? Colors.black : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // History Card List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _historyItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _historyItems[index];
                final isCompleted = item['status'] == 'Completed';

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.book_outlined, color: AppColors.gold),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['expert'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item['topic']} • ${item['date']}",
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.gold.withOpacity(0.1)
                                  : Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['status'].toUpperCase(),
                              style: TextStyle(
                                color: isCompleted ? AppColors.gold : Colors.redAccent,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                item['price'],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item['rating'] != null) ...[
                                const SizedBox(width: 12),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  "${item['rating']}",
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          Row(
                            children: const [
                              Text(
                                'View Detail',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right, color: AppColors.gold, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
