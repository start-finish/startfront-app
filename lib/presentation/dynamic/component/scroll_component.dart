import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

scrollComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SingleChildScrollView(
    scrollDirection: property['scrollDirection'] ?? Axis.vertical,
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
