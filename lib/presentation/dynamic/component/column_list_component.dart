import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

columnListComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Column(
    children: data.children.map((childData) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: (property['space'] as num?)?.toDouble() ?? 0.0,
        ),
        child: DynamicWidgetFactory.createWidget(childData),
      );
    }).toList(),
  );
}
