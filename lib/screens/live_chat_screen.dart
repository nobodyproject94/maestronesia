import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';

// =========================================================================
// LIVECHATSCREEN ADALAH STATEFULWIDGET UNTUK MENGELOLA INTERAKSI OBROLAN TEKS REAL-TIME
// SECARA LANGSUNG DENGAN PAKAR TERTENTU YANG TELAH DIPESAN OLEH PENGGUNA.
// =========================================================================
class LiveChatScreen extends StatefulWidget {
  final Expert expert; // DATA OBJEK PAKAR YANG SEDANG DIAJAK BERKOMUNIKASI.
  final VoidCallback onBack; // CALLBACK SAAT PENGGUNA MENEKAN TOMBOL KEMBALI KE DAFTAR CHAT.
  final VoidCallback onStartVideoCall; // CALLBACK SAAT PENGGUNA MENEKAN TOMBOL PANGGIL VIDEO.
  final ValueChanged<String> onTabChanged; // CALLBACK UNTUK BERPINDAH NAVIGASI KE TAB LAIN.
  final VoidCallback onSignOut; // CALLBACK KETIKA PENGGUNA KELUAR APLIKASI.

  const LiveChatScreen({
    super.key,
    required this.expert,
    required this.onBack,
    required this.onStartVideoCall,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  // =========================================================================
  // CONTROLLER UNTUK MENANGANI INPUT TEKS YANG DIKETIK PENGGUNA DI DALAM TEXTFIELD.
  // =========================================================================
  final TextEditingController _messageController = TextEditingController();
  // =========================================================================
  // CONTROLLER UNTUK MENGONTROL POSISI SCROLL PADA DAFTAR PESAN.
  // =========================================================================
  final ScrollController _scrollController = ScrollController();
  // =========================================================================
  // DAFTAR LOKAL UNTUK MENAMPUNG SELURUH RIWAYAT PESAN SELAMA SESI CHAT AKTIF.
  // =========================================================================
  final List<Map<String, dynamic>> _messages = [];
  // =========================================================================
  // STATE BOOLEAN UNTUK MELACAK STATUS APAKAH PAKAR SEDANG MENSIMULASIKAN MENGETIK.
  // =========================================================================
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // =========================================================================
    // MEMASUKKAN PESAN PEMBUKA DEFAULT DARI PAKAR SAAT PERTAMA KALI LAYAR DIBUKA.
    // =========================================================================
    _messages.add({
      'sender': 'expert',
      'text': 'Hello! Thanks for booking a consultation session with me. How can I help you today?',
      'time': '18:00',
    });
  }

  // =========================================================================
  // FUNGSI UNTUK MENGIRIM PESAN YANG DIINPUT PENGGUNA.
  // =========================================================================
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return; // MENCEGAH PENGIRIMAN PESAN KOSONG.

    setState(() {
      // =========================================================================
      // MENAMBAHKAN PESAN PENGGUNA KE DAFTAR LOKAL.
      // =========================================================================
      _messages.add({
        'sender': 'client',
        'text': text,
        'time': _getCurrentTime(),
      });
      // =========================================================================
      // MENYALAKAN STATUS MENGETIK UNTUK PAKAR SEBAGAI SIMULASI RESPONS.
      // =========================================================================
      _isTyping = true;
    });

    _messageController.clear(); // MENGOSONGKAN TEXTFIELD SETELAH TOMBOL KIRIM DITEKAN.
    _scrollToBottom(); // MENGARAHKAN SCROLL OTOMATIS KE PESAN TERBARU.

    // =========================================================================
    // MENJALANKAN TIMER UNTUK MENSIMULASIKAN BALASAN OTOMATIS DARI PAKAR SETELAH DELAY 1.5 DETIK.
    // =========================================================================
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return; // MENCEGAH PEMBARUAN STATE JIKA WIDGET SUDAH DI-DISPOSE.

      String replyText = '';
      // =========================================================================
      // MEMBERIKAN TEKS BALASAN SPESIFIK BERDASARKAN NAMA PAKAR UNTUK MEMBERIKAN RASA DINAMIS.
      // =========================================================================
      if (widget.expert.name.contains('Sarah')) {
        replyText = 'Understood. For your AI and Informatics project, I suggest we review the neural network layers and model optimization techniques. Have you loaded the training dataset?';
      } else if (widget.expert.name.contains('Hermanto')) {
        replyText = 'Got it. For our engineering session, let\'s analyze the thermodynamic equations and heat transfer ratios. Shall we review the schematics first?';
      } else {
        replyText = 'Great. I can guide you through these principles step-by-step. Feel free to tap the video icon in the top right to start our real-time video session!';
      }

      setState(() {
        // =========================================================================
        // MENAMBAHKAN PESAN BALASAN PAKAR KE DALAM DAFTAR LOKAL.
        // =========================================================================
        _messages.add({
          'sender': 'expert',
          'text': replyText,
          'time': _getCurrentTime(),
        });
        _isTyping = false; // MEMATIKAN STATUS SIMULASI MENGETIK.
      });
      _scrollToBottom(); // MENGARAHKAN KEMBALI SCROLL KE PESAN PALING BAWAH.
    });
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MENDAPATKAN FORMAT WAKTU SAAT INI (HH:MM).
  // =========================================================================
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // =========================================================================
  // FUNGSI UNTUK MENGGESER POSISI LISTVIEW KE TITIK PALING BAWAH SECARA HALUS.
  // =========================================================================
  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // =========================================================================
    // MEMBERSIHKAN CONTROLLERS DARI MEMORY UNTUK MENGHINDARI MEMORY LEAK.
    // =========================================================================
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // VALUELISTENABLEBUILDER MEMANTAU PERUBAHAN STATUS TEMA (GELAP/TERANG).
    // =========================================================================
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'live_chat_list',
          showBottomBar: false, // MENYEMBUNYIKAN BOTTOM NAVIGATION BAR AGAR RUANG CHAT LEBIH LUAS.
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            // =========================================================================
            // HEADER ATAS YANG BERISI PROFIL PAKAR DAN TOMBOL PANGGILAN VIDEO.
            // =========================================================================
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                onPressed: widget.onBack,
              ),
              title: Row(
                children: [
                  // =========================================================================
                  // STACK AVATAR PAKAR DENGAN INDIKATOR STATUS ONLINE DI POJOK KANAN BAWAH.
                  // =========================================================================
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.expert.avatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.expert.status == 'Available' ? AppColors.gold : AppColors.textSecondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF172128) : const Color(0xFF0F2038),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // =========================================================================
                  // MENAMPILKAN NAMA PAKAR DAN STATUS KONEKSI OBROLAN.
                  // =========================================================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.expert.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Online',
                          style: TextStyle(
                            color: AppColors.gold.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                // =========================================================================
                // TOMBOL UNTUK MEMULAI SESI PANGGILAN VIDEO (KONSULTASI TATAP MUKA VIRTUAL).
                // =========================================================================
                IconButton(
                  icon: const Icon(Icons.videocam_rounded, color: AppColors.gold, size: 28),
                  onPressed: widget.onStartVideoCall,
                  tooltip: 'Start Video Consultation',
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Column(
              children: [
                // =========================================================================
                // DAFTAR GELEMBUNG CHAT UTAMA YANG DAPAT DI-SCROLL.
                // =========================================================================
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isClient = msg['sender'] == 'client';

                      // =========================================================================
                      // MENYEJAJARKAN PESAN KE KANAN JIKA PENGIRIM ADALAH CLIENT, KE KIRI JIKA EXPERT.
                      // =========================================================================
                      return Align(
                        alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75, // BATAS LEBAR GELEMBUNG PESAN.
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            // =========================================================================
                            // WARNA GELEMBUNG DISESUAIKAN DENGAN PENGIRIM DAN TEMA.
                            // =========================================================================
                            color: isClient
                                ? (isDark ? AppColors.gold.withOpacity(0.1) : Colors.white.withOpacity(0.15))
                                : (isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05)),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isClient ? const Radius.circular(20) : Radius.zero,
                              bottomRight: isClient ? Radius.zero : const Radius.circular(20),
                            ),
                            border: Border.all(
                              color: isClient ? AppColors.gold.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // =========================================================================
                              // TEKS PESAN YANG DIKIRIMKAN.
                              // =========================================================================
                              Text(
                                msg['text'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // =========================================================================
                              // LABEL PENUNJUK WAKTU PESAN DIKIRIM.
                              // =========================================================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['time'],
                                    style: TextStyle(
                                      color: AppColors.textSecondary.withOpacity(0.5),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // =========================================================================
                // INDIKATOR TEKS BERJALAN JIKA PAKAR SEDANG MENYIMULASIKAN STATUS "MENGETIK...".
                // =========================================================================
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.expert.name.split(' ')[0]} is typing...',
                        style: TextStyle(
                          color: AppColors.gold.withOpacity(0.8),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                // =========================================================================
                // PANEL INPUT TEKS DAN TOMBOL KIRIM DI BAGIAN PALING BAWAH LAYAR CHAT.
                // =========================================================================
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    top: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF172128).withOpacity(0.4) : Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // =========================================================================
                      // KOLOM INPUT TEKS.
                      // =========================================================================
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(), // MENGIRIM PESAN SAAT TOMBOL ENTER DITEKAN DI KEYBOARD.
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // =========================================================================
                      // TOMBOL IKON KIRIM BULAT BERLATAR EMAS.
                      // =========================================================================
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 20,
                          ),
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
