import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import '../databases/database_helper.dart';

class LiveChatListScreen extends StatefulWidget {
  final String email;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const LiveChatListScreen({
    super.key,
    required this.email,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<LiveChatListScreen> createState() => _LiveChatListScreenState();
}

class _LiveChatListScreenState extends State<LiveChatListScreen> {
  late Future<List<Map<String, dynamic>>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = DatabaseHelper.instance.getBookings(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'live_chat_list',
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Consultations',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chat and connect with your booked experts here.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureBookings,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: AppColors.gold),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text(
                            'Error loading chats.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      final bookings = snapshot.data ?? [];
                      // Group bookings to get unique expert IDs
                      final uniqueExpertIds = <int>{};
                      final uniqueBookings = <Map<String, dynamic>>[];

                      for (var b in bookings) {
                        final expertId = b['expert_id'] as int?;
                        if (expertId != null && !uniqueExpertIds.contains(expertId)) {
                          uniqueExpertIds.add(expertId);
                          uniqueBookings.add(b);
                        }
                      }

                      if (uniqueBookings.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: uniqueBookings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = uniqueBookings[index];
                          final expertId = item['expert_id'] as int;

                          // Find expert avatar and other details
                          final expert = mockExperts.firstWhere(
                            (e) => e.id == expertId,
                            orElse: () => mockExperts.first,
                          );

                          return Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: InkWell(
                              onTap: () {
                                widget.onTabChanged('live_chat_expert_$expertId');
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(expert.avatar),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: expert.status == 'Available' ? AppColors.gold : AppColors.textSecondary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark ? const Color(0xFF172128) : const Color(0xFF0F2038),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expert.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            expert.expertise,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: AppColors.gold,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.gold,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Chats',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can start live consultations once you book a session with an expert.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              widget.onTabChanged('dashboard');
            },
            child: const Text('Book an Expert'),
          ),
        ],
      ),
    );
  }
}
