import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

wrapComponent({required DynamicWidgetData data}) {
  final property = data.properties;
  final double? aspectRatio = property['aspectRatio'];

  return Wrap(
    spacing: property['spacing'] ?? 0.0,
    runSpacing: property['runSpacing'] ?? 0.0,
    children: data.children.map((childData) {
      final childWidget = DynamicWidgetFactory.createWidget(childData);

      // Wrap with AspectRatio if aspectRatio is defined
      if (aspectRatio != null) {
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: childWidget,
        );
      } else {
        return childWidget;
      }
    }).toList(),
  );
}
