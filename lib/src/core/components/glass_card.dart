import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/theme.dart';

/// A reusable glassmorphism card widget with backdrop blur effect.
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
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
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
