import 'package:flutter/material.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

iconComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Icon(
    property['icon'] ?? Icons.add_rounded,
    color: property['color'] ?? AppTheme.primary,
    size: (property['size'] as num?)?.toDouble() ?? 24.0,
  );
}
