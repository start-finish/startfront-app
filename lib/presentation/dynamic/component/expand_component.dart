import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

expandedComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Expanded(
    flex: property['flex'] ?? 1,
    child: Container(
      child: data.child != null
          ? DynamicWidgetFactory.createWidget(data.child!)
          : null,
    ),
  );
}
