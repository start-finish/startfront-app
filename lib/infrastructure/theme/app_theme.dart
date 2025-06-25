import 'package:flutter/material.dart';
import '../../app/controllers/theme_controller.dart';

class AppTheme {
  static ThemeController get themeController => ThemeController.to;

  static bool get isDark => themeController.themeMode.value == ThemeMode.dark;

  static Color get primary =>
      isDark ? const Color(0xFF0091EA) : const Color(0xFF1976D2);

  static Color get onPrimary => Colors.white;

  static Color get background =>
      isDark ? const Color(0xFF121212) : const Color(0xFFE9F1F9);

  static Color get onBackground =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF263238);

  static Color get surface => isDark ? const Color(0xFF1E1E1E) : Colors.white;

  static Color get onSurface =>
      isDark ? const Color(0xFFE0E0E0) : const Color(0xFF263238);

  static Color get error =>
      isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F);

  static Color get secondary =>
      isDark ? const Color(0xFF90CAF9) : const Color(0xFF102A43);

  static Color get onSecondary => isDark ? Colors.black : Colors.white;

  /// Success color (solid)
  static Color get success =>
      isDark ? const Color(0xFF4CAF50) : const Color(0xFF388E3C);

  /// Gradient example for primary color
  static LinearGradient get primaryGradient => LinearGradient(
        colors: isDark
            ? [const Color(0xFF0091EA), const Color(0xFF006DB3)]
            : [const Color(0xFF1976D2), const Color(0xFF004BA0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Gradient example for secondary color
  static LinearGradient get secondaryGradient => LinearGradient(
        colors: isDark
            ? [const Color(0xFF90CAF9), const Color(0xFF5D99C6)]
            : [const Color(0xFF102A43), const Color(0xFF1B3B5B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Gradient example for totery color
  static LinearGradient get toteryGradient => LinearGradient(
        colors: isDark
            ? [const Color(0xFF0091EA), const Color(0xFF006DB3)]
            : [const Color(0xFFF0F0F7), const Color(0xA2E2E8FE)],
      );

  /// Gradient for success color
  static LinearGradient get successGradient => LinearGradient(
        colors: isDark
            ? [const Color(0xFF4CAF50), const Color(0xFF357A38)]
            : [const Color(0xFF388E3C), const Color(0xFF2E7031)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
