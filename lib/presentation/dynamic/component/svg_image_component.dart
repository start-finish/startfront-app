import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

svgImageComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SvgPicture.asset(
    property['image'],
    key: Key(property['image'] ?? 'default_key'),
    color: property['color'] ?? AppTheme.primary,
    width: property['width'],
    height: property['height'],
  );
}
