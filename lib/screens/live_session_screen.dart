import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';

// =========================================================================
// LIVESESSIONSCREEN ADALAH STATEFULWIDGET UNTUK MENGELOLA VISUALISASI SESI PANGGILAN VIDEO
// INTERAKTIF YANG DILENGKAPI DENGAN TEKNOLOGI SIMULASI HAMPARAN AUGMENTED REALITY (AR).
// =========================================================================
class LiveSessionScreen extends StatefulWidget {
  final Expert expert; // DATA PAKAR YANG SEDANG MEMANDU SESI LANGSUNG INI.
  final VoidCallback onHangUp; // CALLBACK UNTUK MENGAKHIRI PANGGILAN DAN MENUTUP SESI.

  const LiveSessionScreen({
    super.key,
    required this.expert,
    required this.onHangUp,
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen>
    with SingleTickerProviderStateMixin {
  // =========================================================================
  // ANIMATIONCONTROLLER DIGUNAKAN UNTUK MENGGERAKKAN ANIMASI ELEMEN GRAFIS AR SECARA BERULANG.
  // =========================================================================
  late AnimationController _arController;

  @override
  void initState() {
    super.initState();
    // =========================================================================
    // MENGINISIALISASI KONTROLER ANIMASI BERDURASI 3 DETIK YANG AKAN BERULANG TERUS-MENERUS.
    // =========================================================================
    _arController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    // =========================================================================
    // MENGHAPUS KONTROLER ANIMASI DARI MEMORI SAAT LAYAR INI DITUTUP.
    // =========================================================================
    _arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // =========================================================================
        // STACK MENUMPUK ELEMEN-ELEMEN DI ATAS FEED VIDEO UTAMA (KAMERA BELAKANG/DEPAN).
        // =========================================================================
        body: Stack(
          children: [
            // =========================================================================
            // 1. FEED KAMERA UTAMA SIMULASI (LATAR BELAKANG TRANSPARAN DENGAN IKON STATUS MENGHUBUNGKAN)
            // =========================================================================
            Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      color: AppColors.textSecondary,
                      size: 80,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CONNECTING FEED...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
  
            // =========================================================================
            // 2. HAMPARAN ELEMEN AR (MENGGUNAKAN CUSTOMPAINT DAN DIANIMASIKAN VIA ANIMATEDBUILDER)
            // =========================================================================
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _arController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ARPainter(progress: _arController.value),
                  );
                },
              ),
            ),
  
            // =========================================================================
            // 3. INDIKATOR STATUS PANGGILAN AKTIF DI POJOK KIRI ATAS
            // =========================================================================
            Positioned(
              top: 60,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  children: [
                    // =========================================================================
                    // LAMPU INDIKATOR MERAH BERKEDIP/MENYALA
                    // =========================================================================
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // =========================================================================
                    // WAKTU DURASI PANGGILAN BERJALAN PALSU
                    // =========================================================================
                    const Text(
                      '45:12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 12, color: AppColors.dividerColor),
                    const SizedBox(width: 8),
                    Text(
                      'CALL IN PROGRESS',
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
            ),
  
            // =========================================================================
            // 4. FLOATING VIDEO BOX PAKAR (MENAMPILKAN WAJAH PAKAR DI POJOK KANAN ATAS)
            // =========================================================================
            Positioned(
              top: 100,
              right: 24,
              child: Container(
                width: 110,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.gold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.expert.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // =========================================================================
                    // LABEL NAMA PAKAR DI BAGIAN BAWAH KOTAK MELAYANG.
                    // =========================================================================
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.expert.name.split(' ')[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
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
  
            // =========================================================================
            // 5. SPANDUK INSTRUKSI/PETUNJUK AR DI BAGIAN TENGAH BAWAH
            // =========================================================================
            Positioned(
              bottom: 180,
              left: 24,
              right: 24,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Instruction',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // =========================================================================
                      // TEKS PETUNJUK LANGKAH PEMOSISIAN JARI TANGAN PENGGUNA.
                      // =========================================================================
                      Text(
                        '"Place your index finger on the 2nd fret, 6th string."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
  
            // =========================================================================
            // 6. TOOLBAR NAVIGASI & KONTROL SESI DI BAGIAN BAWAH LAYAR
            // =========================================================================
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 48,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border.all(color: AppColors.dividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // =========================================================================
                    // TOMBOL MUTE MIKROFON
                    // =========================================================================
                    _buildToolbarButton(
                      Icons.mic,
                      AppColors.cardBg,
                      AppColors.textSecondary,
                    ),
                    // =========================================================================
                    // TOMBOL SENTER/FLASHLIGHT
                    // =========================================================================
                    _buildToolbarButton(
                      Icons.flashlight_on,
                      AppColors.cardBg,
                      Colors.amber,
                    ),
                    // =========================================================================
                    // TOMBOL TENGAH EMAS: PENANDA POINTER MOUSE AR
                    // =========================================================================
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.mouse, color: Colors.black, size: 28),
                      ),
                    ),
                    // =========================================================================
                    // TOMBOL TEKS PETUNJUK
                    // =========================================================================
                    _buildToolbarButton(
                      Icons.text_fields,
                      AppColors.cardBg,
                      AppColors.textSecondary,
                    ),
                    // =========================================================================
                    // TOMBOL AKHIRI SESI (HANG UP) DENGAN INDIKATOR WARNA MERAH MENYALA
                    // =========================================================================
                    _buildToolbarButton(
                      Icons.logout,
                      Colors.red.withValues(alpha: 0.1),
                      Colors.red,
                      onTap: widget.onHangUp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MEMPRODUKSI TOMBOL-TOMBOL IKON PADA TOOLBAR.
  // =========================================================================
  Widget _buildToolbarButton(
    IconData icon,
    Color bg,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

// =========================================================================
// ARPAINTER ADALAH CUSTOMPAINTER KUSTOM UNTUK MERENDER LINGKARAN VISUAL TARGET AR
// YANG BERGETAR/ANIMATIF DI ATAS LAYAR VIDEO KONSULTASI PENGGUNA.
// =========================================================================
class ARPainter extends CustomPainter {
  final double progress; // NILAI KEMAJUAN DARI ANIMATIONCONTROLLER (0.0 SAMPAI 1.0).

  ARPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // =========================================================================
    // KONFIGURASI KUAS GAMBAR (PAINT) UNTUK LINGKARAN TARGET.
    // =========================================================================
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // =========================================================================
    // TITIK PUSAT LINGKARAN TARGET DIATUR SEDIKIT DI ATAS TENGAH LAYAR AGAR FOKUS PADA OBJEK.
    // =========================================================================
    final center = Offset(size.width * 0.5, size.height * 0.45);
    const radius = 55.0;

    // =========================================================================
    // MENGGAMBAR LINGKARAN DASAR TARGET.
    // =========================================================================
    canvas.drawCircle(center, radius, paint);

    // =========================================================================
    // KONFIGURASI KUAS GAMBAR UNTUK GARIS PENUNJUK KOORDINAT AR YANG TEGAK LURUS.
    // =========================================================================
    final pointerPaint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // =========================================================================
    // MENGGAMBAR GARIS PENUNJUK VERTIKAL DI BAGIAN ATAS LINGKARAN TARGET.
    // =========================================================================
    canvas.drawLine(
      Offset(center.dx, center.dy - radius - 20),
      Offset(center.dx, center.dy - radius - 5),
      pointerPaint,
    );
  }

  @override
  // =========================================================================
  // SELALU GAMBAR ULANG KANVAS KETIKA STATUS NILAI PROGRESS BERUBAH AGAR ANIMASI BERJALAN MULUS.
  // =========================================================================
  bool shouldRepaint(covariant ARPainter oldDelegate) => true;
}
