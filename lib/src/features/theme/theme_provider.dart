import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final Color primaryColor;
  final Color secondaryColor;
  final Color successColor;
  final Color errorColor;
  final String fontFamily;
  final double baseFontSize;
  final double borderRadius;
  final String shadowIntensity;

  ThemeState({
    required this.primaryColor,
    required this.secondaryColor,
    required this.successColor,
    required this.errorColor,
    required this.fontFamily,
    required this.baseFontSize,
    required this.borderRadius,
    required this.shadowIntensity,
  });

  ThemeState copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? successColor,
    Color? errorColor,
    String? fontFamily,
    double? baseFontSize,
    double? borderRadius,
    String? shadowIntensity,
  }) {
    return ThemeState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      fontFamily: fontFamily ?? this.fontFamily,
      baseFontSize: baseFontSize ?? this.baseFontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowIntensity: shadowIntensity ?? this.shadowIntensity,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(ThemeState(
          primaryColor: const Color(0xFF00D2D2),
          secondaryColor: const Color(0xFF6366F1),
          successColor: const Color(0xFF10B981),
          errorColor: const Color(0xFFEF4444),
          fontFamily: 'Inter',
          baseFontSize: 16.0,
          borderRadius: 8.0,
          shadowIntensity: 'Light',
        ));

  void updatePrimaryColor(Color color) => state = state.copyWith(primaryColor: color);
  void updateSecondaryColor(Color color) => state = state.copyWith(secondaryColor: color);
  void updateSuccessColor(Color color) => state = state.copyWith(successColor: color);
  void updateErrorColor(Color color) => state = state.copyWith(errorColor: color);
  void updateFontFamily(String family) => state = state.copyWith(fontFamily: family);
  void updateBaseFontSize(double size) => state = state.copyWith(baseFontSize: size);
  void updateBorderRadius(double radius) => state = state.copyWith(borderRadius: radius);
  void updateShadowIntensity(String intensity) => state = state.copyWith(shadowIntensity: intensity);
  
  void reset() {
    state = ThemeState(
      primaryColor: const Color(0xFF00D2D2),
      secondaryColor: const Color(0xFF6366F1),
      successColor: const Color(0xFF10B981),
      errorColor: const Color(0xFFEF4444),
      fontFamily: 'Inter',
      baseFontSize: 16.0,
      borderRadius: 8.0,
      shadowIntensity: 'Light',
    );
  }
}

final themeStateProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
