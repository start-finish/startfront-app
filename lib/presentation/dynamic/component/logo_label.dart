import 'package:flutter/material.dart';

import '../data/data.dart';

logoLabel({
  String? subTitle,
  String? isMainAxisSize,
  backgroundColor,
}) {
  return DynamicWidgetData(
    type: 'Container',
    properties: {
      'padding': 8,
      'radius': 8,
      'color': backgroundColor ?? Colors.transparent,
    },
    child: DynamicWidgetData(
      type: 'Row',
      properties: {
        'mainAxisSize': isMainAxisSize ?? 'min',
        'mainAxisAlignment': 'center',
        'crossAxisAlignment': 'center',
        'spacing': 12,
      },
      children: [
        DynamicWidgetData(
          type: 'Image',
          properties: {
            'height': 40,
            'image': 'assets/logo/front_logo.png',
          },
        ),
        DynamicWidgetData(
          type: 'Column',
          properties: {
            'spacing': 4,
            'mainAxisAlignment': 'center',
          },
          children: [
            DynamicWidgetData(
              type: 'Image',
              properties: {
                'height': 16,
                'image': 'assets/logo/front_letter.png',
              },
            ),
            if (subTitle != null)
              DynamicWidgetData(
                type: 'Text',
                properties: {
                  'text': subTitle,
                  'fontSize': 13,
                },
              ),
          ],
        ),
      ],
    ),
  );
}
