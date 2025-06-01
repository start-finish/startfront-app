import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart';

stackComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Stack(
    alignment: parseAlignmentDirectional(property['alignment']),
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
