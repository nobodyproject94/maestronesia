import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme.dart';

import '../databases/database_helper.dart';

// =========================================================================
// HISTORYSCREEN MENAMPILKAN RIWAYAT PEMESANAN SESI KONSULTASI DARI PENGGUNA.
// MEMUNGKINKAN PENGGUNA UNTUK MELIHAT SESI MENDATANG (UPCOMING), SESI SELESAI (COMPLETED), SESI DIBATALKAN (CANCELLED),
// SERTA MENAMBAHKAN CATATAN PERSIAPAN, MENJADWALKAN ULANG (RESCHEDULE), ATAU MEMBATALKAN SESI.
// =========================================================================
class HistoryScreen extends StatefulWidget {
  final String email;
  final String role;
  final String name;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const HistoryScreen({
    super.key,
    required this.email,
    required this.role,
    required this.name,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // =========================================================================
  // OPSI FILTER STATUS PEMESANAN.
  // =========================================================================
  final List<String> _filters = [
    'All Sessions',
    'Completed',
    'Upcoming',
    'Cancelled',
  ];
  int _activeFilterIndex = 0; // STATE PENYIMPAN INDEKS FILTER AKTIF TERPILIH.
  late Future<List<Map<String, dynamic>>> _futureBookings; // FUTURE PENAMPUNG DATA BOOKING DARI SQLITE.

  @override
  void initState() {
    super.initState();
    _refreshBookings(); // MEMUAT DATA BOOKING DARI DATABASE SAAT INISIALISASI STATE PERTAMA KALI.
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MEMUAT ULANG DAFTAR DATA BOOKING DARI DATABASE.
  // =========================================================================
  void _refreshBookings() {
    setState(() {
      _futureBookings = DatabaseHelper.instance.getBookings(
        widget.email,
        role: widget.role,
        name: widget.name,
      );
    });
  }

  // =========================================================================
  // MENAMPILKAN DIALOG MODAL BLUR UNTUK MENAMBAHKAN ATAU MENGEDIT CATATAN SESI.
  // =========================================================================
  void _showAddNoteDialog(Map<String, dynamic> item) {
    final noteController = TextEditingController(text: item['notes'] ?? '');
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // MEMBERIKAN EFEK BLUR DI BELAKANG DIALOG MODAL.
          child: AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF131D24)
                : Colors.white.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
            title: Text(
              item['notes'] == null || item['notes'].toString().isEmpty
                  ? 'Add Note'
                  : 'Edit Note',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              width: 320,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.dividerColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: noteController,
                maxLines: 4,
                style: TextStyle(color: AppColors.inputText, fontSize: 14),
                decoration: InputDecoration(
                  hintText:
                      'Enter session notes or topic preparation details...',
                  hintStyle: TextStyle(color: AppColors.hintText, fontSize: 13),
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
                  // =========================================================================
                  // MEMPERBARUI KOLOM 'NOTES' UNTUK ID BOOKING TERKAIT DI DATABASE.
                  // =========================================================================
                  await DatabaseHelper.instance.updateBooking(item['id'], {
                    'notes': noteController.text,
                  });
                  if (context.mounted) {
                    Navigator.pop(context); // MENUTUP DIALOG SETELAH BERHASIL.
                  }
                  _refreshBookings(); // MEMPERBARUI UI DENGAN MEMUAT ULANG DATA.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                  foregroundColor: AppColors.gold,
                  side: const BorderSide(color: AppColors.gold, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text(
                  'Save Note',
                  style: TextStyle(
                    color: AppColors.gold,
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

  // =========================================================================
  // MENAMPILKAN PEMILIH TANGGAL & WAKTU, LALU MEMICU KONFIRMASI RESCHEDULING SESI KONSULTASI.
  // =========================================================================
  void _showRescheduleDialog(Map<String, dynamic> item) async {
    final isDark = isDarkModeNotifier.value;
    final dialogBgColor = isDark
        ? const Color(0xFF131D24)
        : Colors.white.withValues(alpha: 0.05);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.gold,
                onPrimary: Colors.black,
                surface: dialogBgColor,
                onSurface: Colors.white,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: dialogBgColor,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              datePickerTheme: DatePickerThemeData(
                backgroundColor: dialogBgColor,
                headerBackgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.gold,
                onPrimary: Colors.black,
                surface: dialogBgColor,
                onSurface: Colors.white,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: dialogBgColor,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: dialogBgColor,
                entryModeIconColor: AppColors.gold,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime == null) return;
    if (!mounted) return;

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr =
        "${months[pickedDate.month - 1]} ${pickedDate.day}, ${pickedDate.year}";
    final timeStr = pickedTime.format(context);

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
              'Reschedule Session',
              style: TextStyle(
                color: AppColors.textPrimary,
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
                  // =========================================================================
                  // MEMPERBARUI KOLOM TANGGAL DAN WAKTU SESI BOOKING BARU DI DATABASE.
                  // =========================================================================
                  await DatabaseHelper.instance.updateBooking(item['id'], {
                    'date': dateStr,
                    'time': timeStr,
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _refreshBookings(); // MEMUAT ULANG DATA BOOKING UNTUK MEREFRESH UI LIST.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                  foregroundColor: AppColors.gold,
                  side: const BorderSide(color: AppColors.gold, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: AppColors.gold,
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

  // =========================================================================
  // MENAMPILKAN DIALOG KONFIRMASI UNTUK MEMBATALKAN SESI KONSULTASI MENDATANG (STATUS MENJADI CANCELLED).
  // =========================================================================
  void _showDeleteDialog(Map<String, dynamic> item) {
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
              'Cancel Session',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to cancel the session with ${widget.role == 'expert' ? item['user_email'] : item['expert_name']}?',
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
                  // =========================================================================
                  // MEMPERBARUI STATUS PEMESANAN MENJADI 'CANCELLED' DI DATABASE.
                  // =========================================================================
                  await DatabaseHelper.instance.updateBooking(item['id'], {
                    'status': 'Cancelled',
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  _refreshBookings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : Colors.redAccent.withValues(alpha: 0.35),
                ),
                child: const Text(
                  'Cancel Session',
                  style: TextStyle(
                    color: Colors.redAccent,
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
        return Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0), // JARAK PADDING BAWAH AGAR AMAN DARI NAVIGATION BAR.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // BARIS JUDUL LAYAR DAN TOMBOL MUAT ULANG (REFRESH)
                  // =========================================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Session History',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _refreshBookings,
                        icon: Icon(Icons.refresh, color: AppColors.textSecondary),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // =========================================================================
                  // LIST HORIZONTAL TOMBOL FILTER STATUS SESI
                  // =========================================================================
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

                        // =========================================================================
                        // KONFIGURASI VISUAL WARNA FILTER CHIP BERDASARKAN STATUS AKTIF & TEMA.
                        // =========================================================================
                        if (active) {
                          if (isDark) {
                            bgColor = AppColors.gold;
                            border = Border.all(color: AppColors.gold);
                            textColor = Colors.black;
                          } else {
                            bgColor = Colors.white.withValues(alpha: 0.12);
                            border = Border.all(color: AppColors.gold, width: 1.5);
                            textColor = AppColors.gold;
                          }
                        } else {
                          bgColor = isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05);
                          border = Border.all(color: Colors.white.withValues(alpha: 0.05));
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

                  // =========================================================================
                  // MERENDER DAFTAR SESI TRANSAKSI DENGAN FUTUREBUILDER
                  // =========================================================================
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
                      // =========================================================================
                      // MEMFILTER DATA BOOKING BERDASARKAN STATUS YANG DIPILIH PADA FILTER HORIZONTAL.
                      // =========================================================================
                      final filtered = allBookings.where((b) {
                        if (_activeFilterIndex == 0) return true;
                        final filterStatus = _filters[_activeFilterIndex];
                        if (filterStatus == 'Upcoming' && b['status'] == 'Pending') {
                          return true;
                        }
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
                        physics: const NeverScrollableScrollPhysics(), // SCROLL UTAMA DIATUR OLEH SINGLECHILDSCROLLVIEW DI PARENT.
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final status = item['status'] ?? 'Upcoming';
                          final isCompleted = status == 'Completed';
                          final isCancelled = status == 'Cancelled';
                          final isPending = status == 'Pending';

                          // =========================================================================
                          // MENGATUR NILAI RATING SIMULASI JIKA SESI TELAH SELESAI DILAKUKAN.
                          // =========================================================================
                          double? rating;
                          if (isCompleted) {
                            if (item['expert_name'].toString().contains('Hermanto')) {
                              rating = 5.0;
                            } else {
                              rating = 4.8;
                            }
                          }

                          // =========================================================================
                          // KONFIGURASI VISUAL KARTU SESI TRANSAKSI BERDASARKAN STATUS
                          // =========================================================================
                          Color cardColor = isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05);
                          Color borderColor = Colors.white.withValues(alpha: 0.05);

                          if (isCompleted) {
                            cardColor = isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05);
                          } else if (isCancelled) {
                            cardColor = isDark
                                ? const Color(0xFF172128)
                                : Colors.white.withValues(alpha: 0.02);
                          } else if (isPending) {
                            borderColor = const Color(0xFFE30A16).withValues(alpha: 0.5);
                          } else {
                            borderColor = AppColors.gold.withValues(alpha: 0.3);
                          }

                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isDark && borderColor == Colors.white.withValues(alpha: 0.05) 
                                    ? Colors.white.withValues(alpha: 0.15) 
                                    : borderColor,
                                width: isDark ? 1.5 : 1.0,
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
                                        color: Colors.white.withValues(alpha: 0.05),
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
                                            widget.role == 'expert'
                                                ? (item['user_email'] ?? 'Client').toString().split('@')[0].toUpperCase()
                                                : (item['expert_name'] ?? 'Expert Name'),
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
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
                                    // =========================================================================
                                    // LABEL TAG STATUS BOOKING (COMPLETED, CANCELLED, UPCOMING) DENGAN WARNA ADAPTIF.
                                    // =========================================================================
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.gold.withValues(alpha: 0.1)
                                            : isCancelled
                                            ? Colors.redAccent.withValues(alpha: 0.1)
                                            : Colors.blueAccent.withValues(alpha: 0.1),
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

                                // =========================================================================
                                // MENAMPILKAN CATATAN PERSIAPAN JIKA DATA NOTES TIDAK KOSONG.
                                // =========================================================================
                                if (item['notes'] != null &&
                                    item['notes'].toString().isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.05),
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
                                Divider(color: AppColors.dividerColor, height: 1),
                                const SizedBox(height: 16),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    // =========================================================================
                                    // INFORMASI HARGA DAN RATING SESI.
                                    // =========================================================================
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                            decoration: BoxDecoration(
                                              color: AppColors.dividerColor,
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
                                    // =========================================================================
                                    // MENAMPILKAN TOMBOL-TOMBOL AKSI DINAMIS BERDASARKAN STATUS SESI.
                                    // =========================================================================
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        // =========================================================================
                                        // OPSI AKSI 1: CHAT & PANGGILAN VIDEO (HANYA JIKA SESI UPCOMING).
                                        // =========================================================================
                                        if (status == 'Upcoming') ...[
                                          InkWell(
                                            onTap: () {
                                              widget.onTabChanged('live_chat_expert_${item['expert_id'] ?? 1}');
                                            },
                                            borderRadius: BorderRadius.circular(8),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: AppColors.gold,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Chat',
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
                                        ],
                                        // =========================================================================
                                        // OPSI AKSI 2: RESCHEDULE/BATAL (HANYA JIKA SESI UPCOMING ATAU PENDING).
                                        // =========================================================================
                                        if (status == 'Upcoming' || isPending) ...[
                                          InkWell(
                                            onTap: () => _showRescheduleDialog(item),
                                            borderRadius: BorderRadius.circular(8),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                          InkWell(
                                            onTap: () => _showDeleteDialog(item),
                                            borderRadius: BorderRadius.circular(8),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
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
                                        ],
                                        // =========================================================================
                                        // OPSI AKSI 3: TAMBAH / EDIT CATATAN SESI (TERSEDIA UNTUK SEMUA STATUS BOOKING).
                                        // =========================================================================
                                        InkWell(
                                          onTap: () => _showAddNoteDialog(item),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
        );
      }
    );
  }
}
