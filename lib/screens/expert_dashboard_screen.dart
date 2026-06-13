import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';

// =========================================================================
// EXPERTDASHBOARDSCREEN MERENDER BERANDA KHUSUS UNTUK PENGGUNA YANG BERSTATUS EXPERT.
// MENAMPILKAN STATUS AKTIF (ONLINE/OFFLINE), TOTAL PENDAPATAN (EARNINGS), DAN DAFTAR NOTIFIKASI/REQUEST.
// =========================================================================
class ExpertDashboardScreen extends StatefulWidget {
  final VoidCallback onStartLiveSession;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;
  final String name;

  const ExpertDashboardScreen({
    super.key,
    required this.onStartLiveSession,
    required this.onTabChanged,
    required this.onSignOut,
    required this.name,
  });

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  bool _isOnline = true; // STATE UNTUK MEMANTAU STATUS AKTIF EXPERT (ONLINE / OFFLINE).
  
  List<Map<String, dynamic>> incomingRequests = [
    {
      'id': 1,
      'user_email': 'john.doe@example.com',
      'topic': 'Flutter Architecture Review',
      'time': 'Tomorrow, 10:00 AM',
      'status': 'Pending',
    },
    {
      'id': 2,
      'user_email': 'jane.smith@example.com',
      'topic': 'Dart Async Debugging',
      'time': 'Friday, 02:00 PM',
      'status': 'Pending',
    }
  ];

  List<Map<String, dynamic>> upcomingSessions = [
    {
      'id': 3,
      'user_email': 'alice.wong@example.com',
      'topic': 'State Management Setup',
      'time': 'Today, 04:00 PM',
      'status': 'Live', // THIS ONE IS CURRENTLY LIVE
    },
    {
      'id': 4,
      'user_email': 'bob.miller@example.com',
      'topic': 'Firebase Auth Integration',
      'time': 'Thursday, 09:00 AM',
      'status': 'Accepted',
    }
  ];

  void _handleAccept(int requestId) {
    setState(() {
      final request = incomingRequests.firstWhere((r) => r['id'] == requestId);
      request['status'] = 'Accepted';
      incomingRequests.remove(request);
      upcomingSessions.add(request);
    });
    showCustomSnackBar(context, 'Request accepted successfully');
  }

  void _handleDecline(int requestId) {
    setState(() {
      incomingRequests.removeWhere((r) => r['id'] == requestId);
    });
    showCustomSnackBar(context, 'Request declined', isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
            backgroundColor: Colors.transparent, // TRANSPARAN AGAR GRADIEN BACKGROUND TERLIHAT.
            body: SingleChildScrollView(
              // =========================================================================
              // PHYSICS BOUNCINGSCROLLPHYSICS UNTUK SCROLLING YANG MULUS DENGAN PANTULAN DI IOS.
              // =========================================================================
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  // =========================================================================
                  // HEADER BANNER: LATAR BELAKANG EMAS JIKA MODE GELAP, DAN PUTIH TRANSPARAN TIPIS JIKA MODE TERANG.
                  // =========================================================================
                  Container(
                    color: isDark ? const Color(0xFF131D24) : Colors.white.withValues(alpha: 0.05),
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 24,
                      left: 24,
                      right: 24,
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textPrimary : AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    color: isDark ? AppColors.gold : AppColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // =========================================================================
                          // SWITCH TOGGLE UNTUK MENGAKTIFKAN/NONAKTIFKAN STATUS ONLINE PAKAR.
                          // =========================================================================
                          Row(
                            children: [
                              Text(
                                _isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: _isOnline ? Colors.greenAccent : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Switch(
                                value: _isOnline,
                                onChanged: (val) {
                                  setState(() {
                                    _isOnline = val;
                                  });
                                },
                                activeThumbColor: AppColors.gold,
                                inactiveThumbColor: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // =========================================================================
                  // MAIN CONTENT PADDING (BELOW HEADER)
                  // =========================================================================
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================================================
                        // 1. EARNINGS OVERVIEW
                        // =========================================================================
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: isDark 
                                ? LinearGradient(colors: [AppColors.gold.withValues(alpha: 0.15), Colors.transparent], begin: Alignment.topLeft, end: Alignment.bottomRight)
                                : const LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF1A252C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.account_balance_wallet, color: AppColors.gold, size: 32),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'This Month\'s Earnings',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondary : Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp 4.500.000',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textPrimary : Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // =========================================================================
                        // 2. INCOMING REQUESTS SECTION
                        // =========================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Incoming Requests',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: incomingRequests.isNotEmpty ? Colors.redAccent : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${incomingRequests.length}',
                                style: TextStyle(
                                  color: incomingRequests.isNotEmpty ? Colors.white : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (incomingRequests.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'No pending requests',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: incomingRequests.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final request = incomingRequests[index];
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isDark ? AppColors.gold.withValues(alpha: 0.5) : AppColors.gold.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request['user_email'] ?? 'Client',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      request['topic'] ?? '',
                                      style: TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        request['time'] ?? '',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => _handleDecline(request['id']),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.redAccent,
                                              side: const BorderSide(color: Colors.redAccent),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                            ),
                                            child: const Text('Decline'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: MaestronesiaButton(
                                            onPressed: () => _handleAccept(request['id']),
                                            height: 46,
                                            borderRadius: 16,
                                            child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 32),

                        // =========================================================================
                        // 3. UPCOMING SESSIONS SECTION
                        // =========================================================================
                        Text(
                          'Upcoming Consultations',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (upcomingSessions.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'No upcoming consultations',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: upcomingSessions.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final session = upcomingSessions[index];
                              final isLive = session['status'] == 'Live' || index == 0; 
                              return GestureDetector(
                                onTap: () {
                                  // Navigasi ke chat saat diklik
                                  widget.onTabChanged('live_chat_client_${session['user_email']}');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isLive && !isDark ? AppColors.gold.withValues(alpha: 0.1) : AppColors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isLive && !isDark ? AppColors.gold : (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05)),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isLive ? (isDark ? AppColors.gold : Colors.transparent) : Colors.white.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(16),
                                          border: isLive && !isDark ? Border.all(color: AppColors.gold, width: 2.0) : null,
                                          boxShadow: isLive && !isDark
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.gold.withValues(alpha: 0.25),
                                                    blurRadius: 12.0,
                                                    spreadRadius: 1.0,
                                                  )
                                                ]
                                              : [],
                                        ),
                                        child: Icon(
                                          Icons.chat,
                                          color: isLive ? (isDark ? Colors.black : AppColors.gold) : AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              session['user_email'] ?? 'Client',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${session['time']} • ${session['topic']}',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
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
                          ),
                        const SizedBox(height: 60), // BOTTOM PADDING
                      ],
                    ),
                  ),
                ],
              ),
            ),
        );
      }
    );
  }
}
