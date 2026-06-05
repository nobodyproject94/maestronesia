import 'package:flutter/material.dart';
import '../theme.dart';

class InterestingGoogleLogo extends StatelessWidget {
  final double size;
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
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        size: Size(size, size),
        painter: _GooglePainter(),
      ),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;
    final center = Offset(w / 2, h / 2);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: r - paint.strokeWidth / 2);

    // Red sector (top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -2.5, 1.4, false, paint);

    // Yellow sector (left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -4.1, 1.6, false, paint);

    // Green sector (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, -0.9, 1.8, false, paint);

    // Blue sector (right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 0.9, 0.9, false, paint);

    // Blue horizontal bar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(
      Offset(w / 2, h / 2),
      Offset(w - barPaint.strokeWidth / 2, h / 2),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
            Color(0xFF0077B5),
            Color(0xFF004B73),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B5).withOpacity(0.3),
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
