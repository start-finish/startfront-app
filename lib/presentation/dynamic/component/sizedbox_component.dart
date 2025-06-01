import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

sizedBoxComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return SizedBox(
    width: (property['width'] as num?)?.toDouble() ?? 0.0,
    height: (property['height'] as num?)?.toDouble() ?? 0.0,
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
