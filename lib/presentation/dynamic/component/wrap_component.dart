import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

wrapComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Wrap(
    spacing: property['space'] ?? 0.0,
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
