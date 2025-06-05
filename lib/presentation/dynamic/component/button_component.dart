import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../data/data.dart';
import '../data/factory.dart';

buttonComponent({required DynamicWidgetData data}) {
  final property = data.properties; // Make sure properties is not null

  return TouchRippleEffect(
    onTap: () async {
      property['action']?.call();
    },
    backgroundColor: property['color'] ?? Colors.white,
    rippleColor: property['rippleColor'] ?? Colors.white24,
    borderRadius: property['radius'] != null
        ? BorderRadius.only(
            topLeft: Radius.circular(property['radiusTopLeft'] ?? 0.0),
            topRight: Radius.circular(property['radiusTopRight'] ?? 0.0),
            bottomLeft: Radius.circular(property['radiusBottomLeft'] ?? 0.0),
            bottomRight: Radius.circular(property['radiusBottomRight'] ?? 0.0),
          )
        : BorderRadius.circular((property['radius'] as num?)?.toDouble() ?? 12),
    child: data.child != null
        ? DynamicWidgetFactory.createWidget(data.child!)
        : Padding(
            padding: property['padding'] ?? EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (property['leadingIcon'] != null)
                  Icon(
                    property['leadingIcon'] ?? Icons.settings,
                    color: property['leadingIconColor'],
                    size: property['leadingIconSize'] ?? 24.0,
                  ),
                if (property['leadingIcon'] != null) SizedBox(width: 8),
                Text(
                  property['title'] ?? 'data',
                  style: TextStyle(
                    color: property['titleColor'] ?? Colors.black,
                    fontSize: property['titleSize'] ?? 14.0,
                  ),
                ),
                if (property['trailingIcon'] != null)
                  property['trailingIcon'] ?? SizedBox(width: 8),
                if (property['trailingIcon'] != null)
                  property['trailingIcon'] ??
                      Icon(
                        Icons.settings,
                        color: property['trailingIconColor'],
                        size: property['trailingIconSize'] ?? 24.0,
                      ),
              ],
            ),
          ),
  );
}
