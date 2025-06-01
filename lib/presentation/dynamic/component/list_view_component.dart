import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart';

listViewComponent({required DynamicWidgetData data}) {
  final property = data.properties;
  bool reverse = property['reverse'] ?? false;
  bool scroll = property['scroll'] ?? true;

  return ListView(
    shrinkWrap: true,
    reverse: reverse,
    physics: scroll == true
        ? getAdaptiveScrollPhysics()
        : NeverScrollableScrollPhysics(),
    scrollDirection: parseScrollDirection(property['scrollDirection']),
    children: data.children
        .map((childData) => DynamicWidgetFactory.createWidget(childData))
        .toList(),
  );
}
