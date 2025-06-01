import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

rotateComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return RotatedBox(
    quarterTurns: property['angle'] ?? 0,
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
