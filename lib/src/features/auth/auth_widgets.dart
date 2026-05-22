import 'package:flutter/material.dart';
import 'dart:math' as math;

class MeshGradientPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  MeshGradientPainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Base deep background
    canvas.drawRect(rect, Paint()..color = const Color(0xFF020817));

    for (int i = 0; i < colors.length; i++) {
      final double phase = (animationValue + (i * math.pi / 2)) % (2 * math.pi);
      final double x = size.width * (0.5 + 0.3 * math.sin(phase * 0.5 + i));
      final double y = size.height * (0.5 + 0.3 * math.cos(phase * 0.3 + i));
      final double radius = size.width * (0.4 + 0.2 * math.sin(phase * 0.2));

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.15),
            colors[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) => true;
}

class AuroraPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  AuroraPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final double midY = size.height * 0.5;

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 10) {
      final double y =
          midY +
          math.sin(x * 0.005 + animationValue) * 100 * math.sin(animationValue * 0.5) +
          math.cos(x * 0.002 - animationValue * 0.3) * 50;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.1),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, midY - 200, size.width, 400))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) => true;
}

class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    Future.delayed(widget.delay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class GlowingTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onVisibilityToggle;

  const GlowingTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isVisible = true,
    this.onVisibilityToggle,
  });

  @override
  State<GlowingTextField> createState() => _GlowingTextFieldState();
}

class _GlowingTextFieldState extends State<GlowingTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: _isFocused ? 1.0 : 0.6),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _isFocused ? 0.08 : 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? const Color(0xFF00D2D2).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D2D2).withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword && !widget.isVisible,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? const Color(0xFF00D2D2) : Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                      onPressed: widget.onVisibilityToggle,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
