import 'package:flutter/material.dart';

import '../data/data.dart';
import '../data/factory.dart';
import '../data/helper.dart';

containerComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  final gradientKey = property['gradient'] as String?;
  final gradient = gradientFromKey(gradientKey);

  return Container(
    width: (property['width'] as num?)?.toDouble(),
    height: (property['height'] as num?)?.toDouble(),
    padding: (property['padding'] as num?)?.toDouble() != null
        ? EdgeInsets.all((property['padding'] as num?)?.toDouble() ?? 16)
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
    margin: (property['margin'] as num?)?.toDouble() != null
        ? EdgeInsets.all((property['margin'] as num?)?.toDouble() ?? 16)
        : (property['verticalMargin'] as num?)?.toDouble() != null ||
                (property['horizontalMargin'] as num?)?.toDouble() != null
            ? EdgeInsets.symmetric(
                vertical:
                    (property['verticalMargin'] as num?)?.toDouble() ?? 0.0,
                horizontal:
                    (property['horizontalMargin'] as num?)?.toDouble() ?? 0.0,
              )
            : EdgeInsets.only(
                top: (property['topMargin'] as num?)?.toDouble() ?? 0.0,
                bottom: (property['bottomMargin'] as num?)?.toDouble() ?? 0.0,
                left: (property['leftMargin'] as num?)?.toDouble() ?? 0.0,
                right: (property['rightMargin'] as num?)?.toDouble() ?? 0.0,
              ),
    decoration: BoxDecoration(
      color:
          gradient == null ? (property['color'] ?? Colors.transparent) : null,
      gradient: gradient,
      border: Border.all(
        color: property['borderColor'] ?? Colors.transparent,
        width: (property['borderWidth'] as num?)?.toDouble() ?? 0.0,
      ),
      borderRadius: (property['radius'] as num?)?.toDouble() != null
          ? BorderRadius.circular(
              (property['radius'] as num?)?.toDouble() ?? 0.0)
          : BorderRadius.only(
              topLeft: Radius.circular(
                  (property['radiusTopLeft'] as num?)?.toDouble() ?? 0.0),
              topRight: Radius.circular(
                  (property['radiusTopRight'] as num?)?.toDouble() ?? 0.0),
              bottomLeft: Radius.circular(
                  (property['radiusBottomLeft'] as num?)?.toDouble() ?? 0.0),
              bottomRight: Radius.circular(
                  (property['radiusBottomRight'] as num?)?.toDouble() ?? 0.0),
            ),
    ),
    constraints: BoxConstraints(
      minWidth: (property['width'] as num?)?.toDouble() ??
          (property['maxWidth'] as num?)?.toDouble() ??
          0.0,
      maxWidth: (property['width'] as num?)?.toDouble() ??
          (property['maxWidth'] as num?)?.toDouble() ??
          double.infinity,
    ),
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : null,
  );
}
