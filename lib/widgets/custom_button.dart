import 'package:flutter/material.dart';
import '../theme.dart';

class MaestronesiaButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isSelected;
  final double height;
  final double borderRadius;

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

class _MaestronesiaButtonState extends State<MaestronesiaButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 3.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected || _isPressed || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.transparent, // transparent as requested
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: active ? AppColors.gold : Colors.white.withOpacity(0.08),
                  width: active ? 2.0 : 1.5,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.25),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: 1.0,
                        )
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: DefaultTextStyle(
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
