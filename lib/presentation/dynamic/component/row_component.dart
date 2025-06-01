import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart';

rowComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Row(
    mainAxisSize: parseMainAxisSize(property['mainAxisSize'] ?? 'min'),
    mainAxisAlignment:
        parseMainAxisAlignment(data.properties['mainAxisAlignment']),
    crossAxisAlignment:
        parseCrossAxisAlignment(data.properties['crossAxisAlignment']),
    spacing: property['spacing'] ?? 0.0,
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
