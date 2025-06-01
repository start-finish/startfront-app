import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

rowListComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: data.children.map((childData) {
        return Padding(
          padding: EdgeInsets.symmetric(
                  horizontal: property['space'] ?? 0.0,
                ),
          child: DynamicWidgetFactory.createWidget(childData),
        );
      }).toList(),
    ),
  );
}
