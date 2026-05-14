import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart';

/// A reusable glassmorphism card widget with backdrop blur effect.
/// Optimized for Web performance by adjusting blur levels to prevent GPU context loss.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;
  final double backgroundOpacity;
  final double borderOpacity;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blurSigma = 20,
    this.backgroundOpacity = 0.05,
    this.borderOpacity = 0.1,
    this.width,
    this.height,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    // Optimization: Flutter Web CanvasKit can crash or experience context loss 
    // if too many expensive blurs (sigma > 15) are rendered simultaneously.
    final optimizedBlur = kIsWeb ? 10.0 : blurSigma;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: optimizedBlur, sigmaY: optimizedBlur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.whiteGlassColor.withValues(alpha: backgroundOpacity),
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: boxShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
