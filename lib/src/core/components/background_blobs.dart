import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Decorative background blobs with smooth animations for a premium feel.
class BackgroundBlobs extends StatefulWidget {
  const BackgroundBlobs({super.key});

  @override
  State<BackgroundBlobs> createState() => _BackgroundBlobsState();
}

class _BackgroundBlobsState extends State<BackgroundBlobs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep navy base
        Container(color: const Color(0xFF002451)),

        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                // Teal blob - top left
                _Blob(
                  top: 0.08 + 0.05 * math.sin(_controller.value * 2 * math.pi),
                  left: 0.08 + 0.05 * math.cos(_controller.value * 2 * math.pi),
                  size: 180,
                  color: const Color(0xFF00FFFF),
                  opacity: 0.35,
                ),

                // Large purple blob - right
                _Blob(
                  top: 0.25 + 0.1 * math.cos(_controller.value * 2 * math.pi + 1),
                  right: 0.03 + 0.05 * math.sin(_controller.value * 2 * math.pi + 0.5),
                  size: 350,
                  color: const Color(0xFF9370DB),
                  opacity: 0.25,
                ),

                // Small purple blob - bottom left (Hidden on Web for stability)
                if (!kIsWeb)
                  _Blob(
                    bottom: 0.12 + 0.08 * math.sin(_controller.value * 2 * math.pi + 2),
                    left: 0.12 + 0.05 * math.cos(_controller.value * 2 * math.pi + 1.5),
                    size: 120,
                    color: const Color(0xFF800080),
                    opacity: 0.5,
                  ),

                // White blob - bottom right
                _Blob(
                  bottom: 0.08 + 0.06 * math.cos(_controller.value * 2 * math.pi + 3),
                  right: 0.22 + 0.08 * math.sin(_controller.value * 2 * math.pi + 2.5),
                  size: 140,
                  color: Colors.white,
                  opacity: 0.22,
                ),

                // Extra teal accent - center (Hidden on Web for stability)
                if (!kIsWeb)
                  _Blob(
                    top: 0.55 + 0.12 * math.sin(_controller.value * 2 * math.pi + 4),
                    left: 0.4 + 0.1 * math.cos(_controller.value * 2 * math.pi + 3.5),
                    size: 100,
                    color: const Color(0xFF00D2D2),
                    opacity: 0.2,
                  ),
              ],
            );
          },
        ),
      ],
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
  final double opacity;

  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Positioned(
      top: top != null ? mq.height * top! : null,
      left: left != null ? mq.width * left! : null,
      right: right != null ? mq.width * right! : null,
      bottom: bottom != null ? mq.height * bottom! : null,
      child: RepaintBoundary(
        child: Container(
          width: size * 2.5,
          height: size * 2.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
