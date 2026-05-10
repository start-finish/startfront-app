import 'dart:math';
import 'package:flutter/material.dart';

/// Animated decorative background blobs with floating effect.
class BackgroundBlobs extends StatefulWidget {
  const BackgroundBlobs({super.key});

  @override
  State<BackgroundBlobs> createState() => _BackgroundBlobsState();
}

class _BackgroundBlobsState extends State<BackgroundBlobs> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          children: [
            // Deep navy base
            Container(color: const Color(0xFF002451)),

            // Teal blob - top left
            _Blob(
              top: 0.08 + sin(t * pi * 2) * 0.02,
              left: 0.08 + cos(t * pi * 2) * 0.015,
              size: 180,
              color: const Color(0xFF00FFFF).withValues(alpha: 0.35),
              blur: 70,
            ),

            // Large purple blob - right
            _Blob(
              top: 0.25 + cos(t * pi * 2) * 0.03,
              right: 0.03 + sin(t * pi * 2) * 0.02,
              size: 350,
              color: const Color(0xFF9370DB).withValues(alpha: 0.25),
              blur: 120,
            ),

            // Small purple blob - bottom left
            _Blob(
              bottom: 0.12 + sin(t * pi * 2 + 1) * 0.02,
              left: 0.12 + cos(t * pi * 2 + 1) * 0.015,
              size: 120,
              color: const Color(0xFF800080).withValues(alpha: 0.5),
              blur: 60,
            ),

            // White blob - bottom right
            _Blob(
              bottom: 0.08 + cos(t * pi * 2 + 2) * 0.02,
              right: 0.22 + sin(t * pi * 2 + 2) * 0.02,
              size: 140,
              color: Colors.white.withValues(alpha: 0.22),
              blur: 50,
            ),

            // Extra teal accent - center
            _Blob(
              top: 0.55 + sin(t * pi * 2 + 3) * 0.025,
              left: 0.4 + cos(t * pi * 2 + 3) * 0.02,
              size: 100,
              color: const Color(0xFF00D2D2).withValues(alpha: 0.2),
              blur: 80,
            ),
          ],
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;
  final double blur;

  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Positioned(
      top: top != null ? mq.height * top! : null,
      left: left != null ? mq.width * left! : null,
      right: right != null ? mq.width * right! : null,
      bottom: bottom != null ? mq.height * bottom! : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: blur,
              spreadRadius: blur * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
