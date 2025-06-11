import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

rowListComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      spacing: (property['spacing'] as num?)?.toDouble() ?? 0.0,
      children: data.children.map((childData) {
        return DynamicWidgetFactory.createWidget(childData);
      }).toList(),
    ),
  );
}
