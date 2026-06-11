import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import '../databases/database_helper.dart';

// =========================================================================
// LIVECHATLISTSCREEN ADALAH STATEFULWIDGET YANG MENAMPILKAN DAFTAR PERCAKAPAN AKTIF
// ANTARA PENGGUNA (USER) DENGAN PAKAR (EXPERT) YANG TELAH MEREKA PESAN (BOOKING).
// =========================================================================
class LiveChatListScreen extends StatefulWidget {
  final String email; // EMAIL PENGGUNA AKTIF UNTUK MEMFILTER DATA PEMESANAN.
  final ValueChanged<String> onTabChanged; // CALLBACK UNTUK MENANGANI NAVIGASI ANTAR-TAB/LAYAR.
  final VoidCallback onSignOut; // CALLBACK KETIKA PENGGUNA KELUAR DARI APLIKASI.

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
  // =========================================================================
  // OBJEK FUTURE YANG MENAMPUNG DAFTAR RIWAYAT PEMESANAN DARI DATABASE SQLITE.
  // =========================================================================
  late Future<List<Map<String, dynamic>>> _futureBookings;

  @override
  void initState() {
    super.initState();
    // =========================================================================
    // MEMUAT DATA PEMESANAN BERDASARKAN EMAIL PENGGUNA SECARA ASINKRON SAAT INISIALISASI STATE PERTAMA KALI.
    // =========================================================================
    _futureBookings = DatabaseHelper.instance.getBookings(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // VALUELISTENABLEBUILDER DIGUNAKAN UNTUK MENDENGARKAN PERUBAHAN PADA MODE TEMA (GELAP/TERANG).
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        // =========================================================================
        // MAINLAYOUT MEMBUNGKUS HALAMAN INI UNTUK MENYEDIAKAN BOTTOM NAVIGATION BAR TERPADU.
        // =========================================================================
        return MainLayout(
          activeTab: 'live_chat_list',
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            // =========================================================================
            // MENENTUKAN LATAR BELAKANG SCAFFOLD SESUAI STATUS TEMA YANG AKTIF.
            // =========================================================================
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              // =========================================================================
              // BOUNCINGSCROLLPHYSICS MEMBERIKAN EFEK MEMANTUL KHAS IOS SAAT MENCAPAI UJUNG ATAS/BAWAH SCROLL.
              // =========================================================================
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              // =========================================================================
              // MENAMBAHKAN PADDING DI SEKELILING KONTEN UNTUK ESTETIKA TATA LETAK.
              // =========================================================================
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // JUDUL UTAMA HALAMAN KONSULTASI LIVE CHAT.
                  // =========================================================================
                  Text(
                    'Live Consultations',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // =========================================================================
                  // SUBJUDUL DESKRIPTIF.
                  // =========================================================================
                  Text(
                    'Chat and connect with your booked experts here.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // =========================================================================
                  // FUTUREBUILDER DIGUNAKAN UNTUK MERENDER WIDGET BERDASARKAN STATUS DATA DARI DATABASE.
                  // =========================================================================
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureBookings,
                    builder: (context, snapshot) {
                      // =========================================================================
                      // MENAMPILKAN INDIKATOR PEMUATAN (LOADING SPINNER) SAAT MENGAMBIL DATA.
                      // =========================================================================
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: AppColors.gold),
                          ),
                        );
                      }
                      // =========================================================================
                      // MENAMPILKAN PESAN KESALAHAN JIKA TERJADI ERROR SAAT MEMUAT DATA.
                      // =========================================================================
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

                      // =========================================================================
                      // MENDAPATKAN DAFTAR PEMESANAN DARI SNAPSHOT DATA (ATAU LIST KOSONG JIKA NULL).
                      // =========================================================================
                      final bookings = snapshot.data ?? [];
                      
                      // =========================================================================
                      // MENGELOMPOKKAN PEMESANAN AGAR SATU PAKAR HANYA MUNCUL SEKALI DI DAFTAR OBROLAN.
                      // =========================================================================
                      final uniqueExpertIds = <int>{};
                      final uniqueBookings = <Map<String, dynamic>>[];

                      for (var b in bookings) {
                        final expertId = b['expert_id'] as int?;
                        if (expertId != null && !uniqueExpertIds.contains(expertId)) {
                          uniqueExpertIds.add(expertId);
                          uniqueBookings.add(b);
                        }
                      }

                      // =========================================================================
                      // JIKA PENGGUNA BELUM MEMESAN PAKAR APA PUN, TAMPILKAN TAMPILAN KOSONG (EMPTY STATE).
                      // =========================================================================
                      if (uniqueBookings.isEmpty) {
                        return _buildEmptyState();
                      }

                      // =========================================================================
                      // MENAMPILKAN DAFTAR PAKAR YANG TERHUBUNG MELALUI LISTVIEW.SEPARATED.
                      // =========================================================================
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(), // SCROLL DINONAKTIFKAN KARENA DIBUNGKUS SINGLECHILDSCROLLVIEW.
                        shrinkWrap: true, // MEMAKSA LISTVIEW MENYESUAIKAN TINGGI SESUAI JUMLAH ITEMNYA.
                        itemCount: uniqueBookings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = uniqueBookings[index];
                          final expertId = item['expert_id'] as int;

                          // =========================================================================
                          // MENCARI DATA DETAIL PAKAR DARI DAFTAR TIRUAN (MOCKEXPERTS) BERDASARKAN ID.
                          // =========================================================================
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
                              // =========================================================================
                              // AKSI KETIKA ITEM CHAT DIKLIK, BERPINDAH TAB KE PERCAKAPAN LANGSUNG DENGAN PAKAR TERTENTU.
                              // =========================================================================
                              onTap: () {
                                widget.onTabChanged('live_chat_expert_$expertId');
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    // =========================================================================
                                    // STACK DIGUNAKAN UNTUK MELETAKKAN INDIKATOR STATUS DI ATAS AVATAR PAKAR.
                                    // =========================================================================
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(expert.avatar),
                                        ),
                                        // =========================================================================
                                        // INDIKATOR STATUS ONLINE/TERSEDIA DI POJOK KANAN BAWAH AVATAR.
                                        // =========================================================================
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
                                    // =========================================================================
                                    // BAGIAN INFORMASI NAMA DAN KEAHLIAN PAKAR.
                                    // =========================================================================
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
                                    // =========================================================================
                                    // TOMBOL PANAH KANAN SEBAGAI ISYARAT VISUAL INTERAKTIF.
                                    // =========================================================================
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

  // =========================================================================
  // MEMBUAT WIDGET TAMPILAN KOSONG KETIKA TIDAK ADA OBROLAN AKTIF.
  // =========================================================================
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // =========================================================================
          // IKON DEKORATIF CHAT BALON WARNA EMAS.
          // =========================================================================
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
          // =========================================================================
          // TEKS INFORMASI UTAMA.
          // =========================================================================
          Text(
            'No Active Chats',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // =========================================================================
          // TEKS PETUNJUK INSTRUKSI.
          // =========================================================================
          Text(
            'You can start live consultations once you book a session with an expert.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          // =========================================================================
          // TOMBOL AJAKAN UNTUK MEMESAN PAKAR.
          // =========================================================================
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
