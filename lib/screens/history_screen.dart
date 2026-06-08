import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';
import '../databases/database_helper.dart';
import 'live_session_screen.dart';
import '../models/expert.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _filters = [
    'All Sessions',
    'Completed',
    'Upcoming',
    'Cancelled',
  ];
  int _activeFilterIndex = 0;
  String? _currentUserEmail;
  late Future<List<Map<String, dynamic>>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = Future.value([]);
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('session_email') ?? 'client@gmail.com';
    setState(() {
      _currentUserEmail = email;
      _futureBookings = DatabaseHelper.instance.getBookings(email);
    });
  }

  void _refreshBookings() {
    if (_currentUserEmail != null) {
      setState(() {
        _futureBookings = DatabaseHelper.instance.getBookings(_currentUserEmail!);
      });
    }
  }

  void _showAddNoteDialog(Map<String, dynamic> item) {
    final noteController = TextEditingController(text: item['notes'] ?? '');
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF131D24)
                : Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            title: Text(
              item['notes'] == null || item['notes'].toString().isEmpty
                  ? 'Add Note'
                  : 'Edit Note',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              width: 320,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF172128)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: noteController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText:
                      'Enter session notes or topic preparation details...',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.updateBooking(item['id'], {
                    'notes': noteController.text,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _refreshBookings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Note',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> item) async {
    final isDark = isDarkModeNotifier.value;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: Colors.black,
              surface: Color(0xFF131D24),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF131D24)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: Colors.black,
              surface: Color(0xFF131D24),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF131D24)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr =
        "${months[pickedDate.month - 1]} ${pickedDate.day}, ${pickedDate.year}";
    final timeStr = pickedTime.format(context);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF131D24)
                : Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            title: const Text(
              'Reschedule Session',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to reschedule this session to:\n\n📅 $dateStr at ⏰ $timeStr?',
              style: TextStyle(color: AppColors.textPrimary, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.updateBooking(item['id'], {
                    'date': dateStr,
                    'time': timeStr,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _refreshBookings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF131D24)
                : Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            title: const Text(
              'Cancel Session',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to cancel and delete the session with ${item['expert_name']}?',
              style: TextStyle(color: AppColors.textPrimary, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Keep Session',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteBooking(item['id']);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _refreshBookings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel Session',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
        final isDesktop = MediaQuery.of(context).size.width > 768;
        return MainLayout(
          activeTab: 'history',
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isDesktop) ...[
                        Text(
                          'Session History',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      IconButton(
                        onPressed: _refreshBookings,
                        icon: Icon(Icons.refresh, color: AppColors.textSecondary),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
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

                        Color bgColor;
                        Border border;
                        Color textColor;

                        if (active) {
                          if (isDark) {
                            bgColor = AppColors.gold;
                            border = Border.all(color: AppColors.gold);
                            textColor = Colors.black;
                          } else {
                            bgColor = Colors.white.withOpacity(0.12);
                            border = Border.all(color: AppColors.gold, width: 1.5);
                            textColor = AppColors.gold;
                          }
                        } else {
                          bgColor = isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05);
                          border = Border.all(color: Colors.white.withOpacity(0.05));
                          textColor = AppColors.textSecondary;
                        }

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _activeFilterIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: border,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (active && !isDark) ...[
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.gold,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    filter,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // History Card List using FutureBuilder
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
                            'Error loading history sessions.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      final allBookings = snapshot.data ?? [];
                      final filtered = allBookings.where((b) {
                        if (_activeFilterIndex == 0) return true;
                        final filterStatus = _filters[_activeFilterIndex];
                        return b['status'] == filterStatus;
                      }).toList();

                      if (filtered.isEmpty) {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text(
                            'No sessions found in this category.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final status = item['status'] ?? 'Upcoming';
                          final isCompleted = status == 'Completed';
                          final isCancelled = status == 'Cancelled';

                          double? rating;
                          if (isCompleted) {
                            if (item['expert_name'].toString().contains('Hermanto')) {
                              rating = 5.0;
                            } else {
                              rating = 4.8;
                            }
                          }

                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: const Icon(
                                        Icons.book_outlined,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['expert_name'] ?? 'Expert Name',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${item['topic']} • ${item['date']}",
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.gold.withOpacity(0.1)
                                            : isCancelled
                                            ? Colors.redAccent.withOpacity(0.1)
                                            : Colors.blueAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        status.toString().toUpperCase(),
                                        style: TextStyle(
                                          color: isCompleted
                                              ? AppColors.gold
                                              : isCancelled
                                              ? Colors.redAccent
                                              : Colors.blueAccent,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if (status == 'Upcoming') ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final expertId = item['expert_id'] is int
                                                ? item['expert_id']
                                                : int.tryParse(item['expert_id'].toString()) ?? 1;
                                            final expert = mockExperts.firstWhere(
                                              (e) => e.id == expertId,
                                              orElse: () => mockExperts.first,
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LiveSessionScreen(
                                                  expert: expert,
                                                  onHangUp: () => Navigator.pop(context),
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.videocam, size: 18),
                                              SizedBox(width: 8),
                                              Text(
                                                'Start Video Call',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            final expertId = item['expert_id'] is int
                                                ? item['expert_id']
                                                : int.tryParse(item['expert_id'].toString()) ?? 1;
                                            Navigator.pushNamed(
                                              context,
                                              '/chat',
                                              arguments: expertId,
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.gold,
                                            side: const BorderSide(color: AppColors.gold, width: 1.5),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.chat_bubble_outline, size: 18),
                                              SizedBox(width: 8),
                                              Text(
                                                'Direct Chat',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                // Display notes if present
                                if (item['notes'] != null &&
                                    item['notes'].toString().isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                    ),
                                    child: Text(
                                      "Note: ${item['notes']}",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 16),
                                const Divider(color: Colors.white10, height: 1),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item['price'] ?? 'Rp 0',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (rating != null) ...[
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
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "$rating",
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            // Reschedule action (Upcoming only)
                                            if (status == 'Upcoming') ...[
                                              InkWell(
                                                onTap: () => _showRescheduleDialog(item),
                                                borderRadius: BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.edit_calendar,
                                                        color: AppColors.gold,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Reschedule',
                                                        style: TextStyle(
                                                          color: AppColors.gold,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              InkWell(
                                                onTap: () => _showDeleteDialog(item),
                                                borderRadius: BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.redAccent,
                                                        size: 14,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.redAccent,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                            // Add/Edit Note action (Any status)
                                            InkWell(
                                              onTap: () => _showAddNoteDialog(item),
                                              borderRadius: BorderRadius.circular(8),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.note_add_outlined,
                                                      color: AppColors.textSecondary,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item['notes'] == null ||
                                                              item['notes']
                                                                  .toString()
                                                                  .isEmpty
                                                          ? 'Add Note'
                                                          : 'Edit Note',
                                                      style: TextStyle(
                                                        color: AppColors.textSecondary,
                                                        fontSize: 12,
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
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 110), // Extra space to clear the floating bottom bar
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
