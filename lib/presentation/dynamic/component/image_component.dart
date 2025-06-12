import 'package:flutter/material.dart';

import '../data/data.dart';

imageComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Opacity(
    opacity: (property['opacity'] as num?)?.toDouble() ?? 1.0,
    child: Image.asset(
      property['image'],
      height: (property['height'] as num?)?.toDouble(),
      width: (property['width'] as num?)?.toDouble(),
      repeat: property['repeat'] ?? ImageRepeat.noRepeat,
    ),
  );
}
