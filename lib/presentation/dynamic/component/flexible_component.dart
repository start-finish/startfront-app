import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

flexibleComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Flexible(
    flex: property['flex'] ?? 1, // Default flex is 1 if not provided
    child: Container(
      child: data.child != null
          ? DynamicWidgetFactory.createWidget(data.child!)
          : null,
    ),
  );
}
