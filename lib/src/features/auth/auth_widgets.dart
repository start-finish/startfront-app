import 'package:flutter/material.dart';
import 'dart:math' as math;

// ---------------------------------------------------------------------------
// Background Painters — smoother, lower-frequency, layered blobs
// ---------------------------------------------------------------------------

class MeshGradientPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  MeshGradientPainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color(0xFF020817));

    // Slow, organic blob movement — each blob has its own phase offset and
    // uses low-frequency sine/cosine so motion feels fluid and cinematic.
    for (int i = 0; i < colors.length; i++) {
      // Primary slow drift
      final double phase = animationValue + (i * math.pi * 0.6);
      final double x = size.width  * (0.5 + 0.28 * math.sin(phase * 0.18 + i * 0.8));
      final double y = size.height * (0.5 + 0.28 * math.cos(phase * 0.14 + i * 0.6));

      // Radius breathes gently
      final double radius =
          size.width * (0.38 + 0.10 * math.sin(phase * 0.09 + i));

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.18),
            colors[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Extra subtle ambient layer — very slow, large, low-opacity
    for (int i = 0; i < colors.length; i++) {
      final double phase = animationValue * 0.5 + i * math.pi * 0.9;
      final double x = size.width  * (0.5 + 0.40 * math.cos(phase * 0.07 + i * 1.2));
      final double y = size.height * (0.5 + 0.35 * math.sin(phase * 0.05 + i * 0.9));
      final double radius = size.width * 0.55;

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.07),
            colors[i].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class AuroraPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  AuroraPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Two overlapping aurora bands at different depths for parallax feel
    _drawBand(canvas, size, animationValue, 0.48, 0.003, 0.0012, 70, 35, 0.08);
    _drawBand(canvas, size, animationValue, 0.58, 0.002, 0.0008, 50, 20, 0.05);
  }

  void _drawBand(
    Canvas canvas,
    Size size,
    double t,
    double yRatio,
    double freq1,
    double freq2,
    double amp1,
    double amp2,
    double opacity,
  ) {
    final Path path = Path();
    final double midY = size.height * yRatio;

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 8) {
      final double y = midY +
          math.sin(x * freq1 + t * 0.4) * amp1 * math.sin(t * 0.15) +
          math.cos(x * freq2 - t * 0.22) * amp2;
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
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, midY - 150, size.width, 300))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// ---------------------------------------------------------------------------
// Staggered Entrance
// ---------------------------------------------------------------------------

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

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
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

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

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
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

// ---------------------------------------------------------------------------
// GlowingTextField — with hover-animated eye icon
// ---------------------------------------------------------------------------

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
  bool _isEyeHovered = false;

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
            color: Colors.white
                .withValues(alpha: _isFocused ? 0.08 : 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused
                  ? const Color(0xFF00D2D2).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color:
                          const Color(0xFF00D2D2).withValues(alpha: 0.15),
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
              hintStyle:
                  TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused
                    ? const Color(0xFF00D2D2)
                    : Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
              suffixIcon: widget.isPassword
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) =>
                          setState(() => _isEyeHovered = true),
                      onExit: (_) =>
                          setState(() => _isEyeHovered = false),
                      child: GestureDetector(
                        onTap: widget.onVisibilityToggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _isEyeHovered
                                ? const Color(0xFF00D2D2)
                                    .withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.isVisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _isEyeHovered
                                ? const Color(0xFF00D2D2)
                                : Colors.white.withValues(alpha: 0.3),
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// HoverTextButton — reusable animated inline text link
// ---------------------------------------------------------------------------

class HoverTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const HoverTextButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w600,
  });

  @override
  State<HoverTextButton> createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<HoverTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          style: TextStyle(
            color: _hovered
                ? widget.color
                : widget.color.withValues(alpha: 0.65),
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            decoration: _hovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: widget.color,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
