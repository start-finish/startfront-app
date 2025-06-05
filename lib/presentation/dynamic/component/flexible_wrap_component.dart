import 'package:flexible_wrap/flexible_wrap.dart';

import '../data/data.dart';
import '../data/factory.dart';

flexibleWrapComponent({required DynamicWidgetData data}) {
  final property = data.properties;
  final double? aspectRatio = property['aspectRatio'];

  return FlexibleWrap(
    spacing: property['spacing'] ?? 0.0,
    runSpacing: property['runSpacing'] ?? 0.0,
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
