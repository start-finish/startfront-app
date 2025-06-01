import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';

paddingComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  return Padding(
    padding: property['padding'] != null
        ? EdgeInsets.all((property['padding'] as num?)?.toDouble() ?? 0.0)
        : (property['verticalPadding'] as num?)?.toDouble() != null ||
                (property['horizontalPadding'] as num?)?.toDouble() != null
            ? EdgeInsets.symmetric(
                vertical:
                    (property['verticalPadding'] as num?)?.toDouble() ?? 0.0,
                horizontal:
                    (property['horizontalPadding'] as num?)?.toDouble() ?? 0.0,
              )
            : EdgeInsets.only(
                top: (property['topPadding'] as num?)?.toDouble() ?? 0.0,
                bottom: (property['bottomPadding'] as num?)?.toDouble() ?? 0.0,
                left: (property['leftPadding'] as num?)?.toDouble() ?? 0.0,
                right: (property['rightPadding'] as num?)?.toDouble() ?? 0.0,
              ),
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
