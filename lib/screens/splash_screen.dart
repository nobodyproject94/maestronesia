import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// SPLASHSCREEN ADALAH STATEFULWIDGET YANG MENYAJIKAN LAYAR SELAMAT DATANG PEMBUKA (SPLASH SCREEN)
// YANG MEMUTAR ANIMASI LOGO TRANSISI SKALA DAN OPASITAS SAAT PERTAMA KALI APLIKASI DIJALANKAN.
// =========================================================================
class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish; // CALLBACK YANG DIPICU UNTUK BERPINDAH LAYAR SETELAH DURASI SPLASH SCREEN SELESAI.

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // =========================================================================
  // KONTROLER UTAMA UNTUK MENGATUR JALANNYA ANIMASI LOGO.
  // =========================================================================
  late AnimationController _controller;
  // =========================================================================
  // ANIMASI TRANSISI SKALA (UKURAN) LOGO.
  // =========================================================================
  late Animation<double> _scaleAnimation;
  // =========================================================================
  // ANIMASI TRANSISI OPASITAS (EFEK MEMUDAR/FADE-IN) LOGO.
  // =========================================================================
  late Animation<double> _fadeAnimation;
  // =========================================================================
  // TIMER UNTUK MELACAK DURASI TAMPIL LAYAR SEBELUM BERPINDAH HALAMAN.
  // =========================================================================
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    // =========================================================================
    // MENGINISIALISASI ANIMATIONCONTROLLER DENGAN DURASI TRANSISI SELAMA 1200 MILIDETIK (1.2 DETIK).
    // =========================================================================
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // =========================================================================
    // ANIMASI SKALA LOGO YANG MEMBESAR SECARA HALUS DARI UKURAN 80% KE 100% MENGGUNAKAN KURVA EASEOUTCUBIC.
    // =========================================================================
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // =========================================================================
    // ANIMASI OPASITAS YANG MENGUBAH LOGO DARI TRANSPARAN PENUH (0.0) KE SOLID PENUH (1.0).
    // =========================================================================
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // =========================================================================
    // MEMULAI PEMUTARAN ANIMASI MAJU.
    // =========================================================================
    _controller.forward();

    // =========================================================================
    // MEMICU CALLBACK NAVIGASI PINDAH LAYAR OTOMATIS SETELAH DURASI DIAM TOTAL SELAMA 2 DETIK (2000 MILIDETIK).
    // =========================================================================
    _progressTimer = Timer(const Duration(milliseconds: 2000), () {
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    // =========================================================================
    // MEMBEBASKAN SUMBER DAYA KONTROLER ANIMASI DARI MEMORI.
    // =========================================================================
    _controller.dispose();
    // =========================================================================
    // MEMBATALKAN TIMER BERJALAN JIKA WIDGET DI-DISPOSE SEBELUM DURASI TIMER SELESAI.
    // =========================================================================
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // TRANSPARAN AGAR LATAR BELAKANG GRADIEN TERLIHAT JELAS.
        body: Stack(
          alignment: Alignment.center,
          children: [
            // =========================================================================
            // AKSEN VISUAL LINGKARAN EMAS REDUP (BLURRED BACKGROUND DECORATION) DI BELAKANG LOGO.
            // =========================================================================
            Positioned(
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.04),
                ),
                child: const SizedBox.shrink(),
              ),
            ),
            Center(
              // =========================================================================
              // ANIMATEDBUILDER MENGGAMBAR ULANG ELEMEN ANAK (CHILD) SETIAP KALI NILAI ANIMASI BERUBAH.
              // =========================================================================
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value, // MENGATUR KEBURAMAN LOGO SESUAI KEMAJUAN ANIMASI.
                    child: Transform.scale(
                      scale: _scaleAnimation.value, // MENGATUR SKALA PERBESARAN LOGO SESUAI KEMAJUAN ANIMASI.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // =========================================================================
                          // MENAMPILKAN ASET GAMBAR LOGO APLIKASI UTAMA MAESTRONESIA.
                          // =========================================================================
                          Image.asset(
                            'assets/logo.png',
                            width: 340,
                            height: 340,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
