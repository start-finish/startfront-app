import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// StartFront brand colors and theme system.
class AppTheme {
  AppTheme._();

  // ── Brand Colors ──
  static const Color primaryColor = Color(0xFF00D2D2); // Teal/Cyan
  static const Color secondaryColor = Color(0xFF8A2BE2); // Purple
  static const Color backgroundColor = Color(0xFF001F3F); // Deep Navy
  static const Color surfaceColor = Color(0xFF082D4F); // Slightly lighter navy
  static const Color cardColor = Color(0xFF0A3158); // Card surface

  static const Color blackGlassColor = Color(0x7F000000); // Black 50%
  static const Color whiteGlassColor = Color(0x78FFFFFF); // White 35%
  static const Color textColor = Color(0xFFFFFFFF); // White 100%

  // ── Gradient Presets ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D2D2), Color(0xFF00A5A5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8A2BE2), Color(0xFF6A1FB2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF082D4F), Color(0xFF0A3D6B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Glassmorphism Decoration ──
  static BoxDecoration glassDecoration({
    double borderRadius = 16,
    double opacity = 0.05,
    double borderOpacity = 0.1,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      border: Border.all(color: Colors.white.withValues(alpha: borderOpacity)),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  // ── Shadows ──
  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.15),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // ── Theme Data ──
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(baseTextTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      iconTheme: const IconThemeData(color: Colors.white70, size: 22),
      dividerColor: Colors.white10,
      splashColor: primaryColor.withValues(alpha: 0.1),
      highlightColor: primaryColor.withValues(alpha: 0.05),
    );
  }
}
