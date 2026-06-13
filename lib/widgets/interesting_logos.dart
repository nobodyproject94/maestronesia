import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// INTERESTINGGOOGLELOGO ADALAH WIDGET KUSTOM YANG MENGGAMBARKAN LOGO GOOGLE MENGGUNAKAN GAMBAR VECTOR CUSTOMPAINTER
// DENGAN TAMBAHAN EFEK GRADIEN LATAR BELAKANG LINGKARAN TRANSPARAN DAN BAYANGAN LEMBUT DI SISINYA.
// =========================================================================
class InterestingGoogleLogo extends StatelessWidget {
  final double size; // UKURAN LOGO DI DALAM KONTAINER.
  const InterestingGoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/google.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

// =========================================================================
// INTERESTINGLINKEDINLOGO MERENDER KONTAINER BERGRADIEN BIRU DENGAN TEKS IKONIK "IN"
// YANG MEMILIKI AKSEN BORDER EMAS UNTUK TOMBOL MASUK DENGAN AKUN LINKEDIN.
// =========================================================================
class InterestingLinkedInLogo extends StatelessWidget {
  final double size;
  const InterestingLinkedInLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0077B5), // WARNA BIRU KHAS LINKEDIN.
            Color(0xFF004B73),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B5).withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          'in',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.85,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
