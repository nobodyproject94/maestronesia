import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// MAESTRONESIA BUTTON ADALAH WIDGET TOMBOL KUSTOM (STATEFUL) DENGAN EFEK SENTUH, HOVER, DAN PENDARAN CAHAYA (GLOW).
// =========================================================================
class MaestronesiaButton extends StatefulWidget {
  final VoidCallback? onPressed; // AKSI CALLBACK KETIKA TOMBOL DITEKAN.
  final Widget child; // WIDGET KONTEN DI DALAM TOMBOL (BIASANYA TEKS).
  final bool isSelected; // STATUS APAKAH TOMBOL SEDANG TERPILIH SECARA DEFAULT.
  final double height; // TINGGI TOMBOL.
  final double borderRadius; // SUDUT KELENGKUNGAN TOMBOL.

  const MaestronesiaButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isSelected = false,
    this.height = 60,
    this.borderRadius = 20,
  });

  @override
  State<MaestronesiaButton> createState() => _MaestronesiaButtonState();
}

class _MaestronesiaButtonState extends State<MaestronesiaButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false; // STATE UNTUK MENDETEKSI KURSOR HOVER (DESKTOP/WEB).
  bool _isPressed = false; // STATE UNTUK MENDETEKSI AKSI TAP/SENTUH AKTIF.
  late AnimationController
  _glowController; // CONTROLLER ANIMASI UNTUK EFEK PENDARAN BAYANGAN.
  late Animation<double> _glowAnimation; // ANIMASI NILAI RADIUS PENDARAN.

  @override
  void initState() {
    super.initState();
    // =========================================================================
    // MENGINISIALISASI CONTROLLER ANIMASI PENDARAN YANG BERULANG (REVERSE SECARA BERULANG).
    // =========================================================================
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    // =========================================================================
    // MENGUBAH NILAI PENDARAN BAYANGAN DARI 3.0 KE 12.0 SECARA HALUS DENGAN KURVA EASEINOUT.
    // =========================================================================
    _glowAnimation = Tween<double>(begin: 3.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController
        .dispose(); // MEMBEBASKAN RESOURCE CONTROLLER ANIMASI DARI MEMORI.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // TOMBOL DIANGGAP AKTIF JIKA DIPILIH SECARA EKSPLISIT, SEDANG DI-HOVER, ATAU SEDANG DITEKAN.
    // =========================================================================
    final bool active = widget.isSelected || _isPressed || _isHovered;

    return MouseRegion(
      // =========================================================================
      // MENDETEKSI PERGERAKAN MOUSE MASUK DAN KELUAR UNTUK MERENDER ULANG STATE HOVER.
      // =========================================================================
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        // =========================================================================
        // MENDETEKSI SENTUHAN LAYAR (DOWN, UP, CANCEL, TAP).
        // =========================================================================
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ), // TRANSISI PERUBAHAN WARNA DAN BAYANGAN SELAMA 200MS.
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors
                    .transparent, // WARNA LATAR BELAKANG TOMBOL DIATUR TRANSPARAN SESUAI KONSEP UI.
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  // =========================================================================
                  // MENGUBAH WARNA DAN KETEBALAN GARIS TEPI JIKA TOMBOL SEDANG AKTIF (WARNA EMAS).
                  // =========================================================================
                  color: active
                      ? AppColors.gold
                      : Colors.white.withOpacity(0.08),
                  width: active ? 2.0 : 1.5,
                ),
                boxShadow: active
                    ? [
                        // =========================================================================
                        // MENAMBAHKAN BAYANGAN PENDARAN EMAS JIKA TOMBOL AKTIF.
                        // =========================================================================
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.25),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: 1.0,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: DefaultTextStyle(
            // =========================================================================
            // GAYA TEKS DI DALAM TOMBOL AKAN BERUBAH WARNA MENJADI EMAS JIKA AKTIF.
            // =========================================================================
            style: TextStyle(
              color: active ? AppColors.gold : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
