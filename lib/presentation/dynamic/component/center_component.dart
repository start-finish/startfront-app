import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

centerComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Center(
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
