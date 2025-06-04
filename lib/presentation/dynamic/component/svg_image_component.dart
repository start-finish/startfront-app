import 'package:flutter_svg/flutter_svg.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

svgImageComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SvgPicture.asset(
    property['image'],
    color: property['color'] ?? AppTheme,
    width: property['width'] ?? 32,
    height: property['height'] ?? 32,
  );
}
