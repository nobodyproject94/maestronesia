import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';

class LiveSessionScreen extends StatefulWidget {
  final Expert expert;
  final VoidCallback onHangUp;

  const LiveSessionScreen({
    Key? key,
    required this.expert,
    required this.onHangUp,
  }) : super(key: key);

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _arController;

  @override
  void initState() {
    super.initState();
    _arController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Simulated Main Camera Feed (Dark grey placeholder with camera icon)
          Container(
            color: const Color(0xFF131D24),
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.videocam_outlined,
                    color: AppColors.textSecondary,
                    size: 80,
                  ),
                  SizedBox(height: 12),
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

          // AR Custom Painter overlay
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

          // Top status indicator (Call in progress)
          Positioned(
            top: 60,
            left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '45:12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 12, color: Colors.white10),
                  const SizedBox(width: 8),
                  const Text(
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

          // Expert Floating Video Box
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
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.expert.avatar),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
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

          // Translation/Instruction overlay banner
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
                  color: AppColors.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Instruction',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
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

          // Bottom Session Toolbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 24, bottom: 48, left: 24, right: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildToolbarButton(Icons.mic, Colors.white10, AppColors.textSecondary),
                  _buildToolbarButton(Icons.flashlight_on, Colors.white10, Colors.amber),
                  // Centered Highlight Mouse Pointer Tool
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
                      child: const Icon(
                        Icons.mouse,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                  _buildToolbarButton(Icons.text_fields, Colors.white10, AppColors.textSecondary),
                  // Hangup button
                  _buildToolbarButton(
                    Icons.logout,
                    Colors.red.withOpacity(0.1),
                    Colors.red,
                    onTap: widget.onHangUp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}

class ARPainter extends CustomPainter {
  final double progress;

  ARPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.5, size.height * 0.45);
    final radius = 55.0;

    // Draw circular pointer with dashed pattern mock
    canvas.drawCircle(center, radius, paint);

    // Draw pointing vectors
    final pointerPaint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, center.dy - radius - 20),
      Offset(center.dx, center.dy - radius - 5),
      pointerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ARPainter oldDelegate) => true;
}
