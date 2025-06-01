import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart';

columnComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Column(
    mainAxisAlignment: parseMainAxisAlignment(property['mainAxisAlignment']),
    crossAxisAlignment: parseCrossAxisAlignment(property['crossAxisAlignment']),
    mainAxisSize: parseMainAxisSize(property['mainAxisSize']),
    spacing: property['spacing'] ?? 0.0,
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
