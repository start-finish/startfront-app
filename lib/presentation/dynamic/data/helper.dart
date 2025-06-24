// Utility functions
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/theme/app_theme.dart';

String colorToHexs(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

Color hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor'; // Add alpha if missing
  return Color(int.parse('0x$hexColor'));
}

bool isValidHex(String hex) {
  final validHex = RegExp(r'^#?([0-9a-fA-F]{6})$');
  return validHex.hasMatch(hex);
}

Color getContrastingTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

// Helper method to parse MainAxisAlignment
MainAxisAlignment parseMainAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'center':
      return MainAxisAlignment.center;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    case 'end':
      return MainAxisAlignment.end;
    case 'start':
    default:
      return MainAxisAlignment.start;
  }
}

// Helper method to parse CrossAxisAlignment
CrossAxisAlignment parseCrossAxisAlignment(String? alignment) {
  switch (alignment) {
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
    case 'start':
    default:
      return CrossAxisAlignment.start;
  }
}

MainAxisSize parseMainAxisSize(String? axis) {
  switch (axis) {
    case 'max':
      return MainAxisSize.max;
    case 'min':
      return MainAxisSize.min;
    default:
      return MainAxisSize.max;
  }
}

// Helper method to parse AlignmentDirectional
AlignmentDirectional parseAlignmentDirectional(String? alignment) {
  switch (alignment) {
    case 'topStart':
      return AlignmentDirectional.topStart;
    case 'topCenter':
      return AlignmentDirectional.topCenter;
    case 'topEnd':
      return AlignmentDirectional.topEnd;
    case 'centerStart':
      return AlignmentDirectional.centerStart;
    case 'center':
      return AlignmentDirectional.center;
    case 'centerEnd':
      return AlignmentDirectional.centerEnd;
    case 'bottomStart':
      return AlignmentDirectional.bottomStart;
    case 'bottomCenter':
      return AlignmentDirectional.bottomCenter;
    case 'bottomEnd':
      return AlignmentDirectional.bottomEnd;
    default:
      return AlignmentDirectional.topStart;
  }
}

// Helper method to parse ScrollDirection ListView
Axis parseScrollDirection(String? scrollDirection) {
  switch (scrollDirection) {
    case 'horizontal':
      return Axis.horizontal;
    case 'vertical':
      return Axis.vertical;
    default:
      return Axis.vertical;
  }
}

// Helper method to parse ScrollDirection ListView
FontWeight parseFontWeight(String? fontWeight) {
  switch (fontWeight) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    case 'w100':
      return FontWeight.w100;
    case 'w200':
      return FontWeight.w200;
    case 'w300':
      return FontWeight.w300;
    case 'w400':
      return FontWeight.w400;
    case 'w500':
      return FontWeight.w500;
    case 'w600':
      return FontWeight.w600;
    case 'w700':
      return FontWeight.w700;
    case 'w800':
      return FontWeight.w800;
    case 'w900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

parseRotate(double? rotate) {
  switch (rotate) {
    case 0:
      return 0;
    case 90:
      return 3.14159 / 2;
    case 180:
      return 3.14159;
    case 270:
      return 3 * (3.14159 / 2);
    case 360:
      return 2 * 3.14159;
    default:
      return 0;
  }
}

// Helper function to get adaptive scroll physics based on platform
ScrollPhysics getAdaptiveScrollPhysics() {
  if (kIsWeb) {
    // For web, typically ClampingScrollPhysics is used, but it can be customized
    return ClampingScrollPhysics();
  } else if (Platform.isIOS) {
    return BouncingScrollPhysics(); // iOS behavior
  } else if (Platform.isAndroid) {
    return ClampingScrollPhysics(); // Android behavior
  } else {
    return ClampingScrollPhysics(); // Fallback for other platforms
  }
}

// Get gradient from property key, fallback to null
LinearGradient? gradientFromKey(String? key) {
  switch (key) {
    case 'primary':
      return AppTheme.primaryGradient;
    case 'secondary':
      return AppTheme.secondaryGradient;
    case 'totery':
      return AppTheme.toteryGradient;
    case 'success':
      return AppTheme.successGradient;
    default:
      return null;
  }
}
