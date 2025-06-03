import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/component/logo_label.dart';
import '../../../dynamic/data/data.dart';

class AdminDashboardController extends GetxController {
  List<String> texts = [
    'Hello',
    'Welcome',
    'Admin',
    'Hello',
    'Welcome',
    'Admin',
    'Hello',
    'Welcome',
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  double screenWidth = MediaQuery.of(Get.context!).size.width;

  int getColumnCount(double width) {
    if (width >= 1000) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  double getItemWidth(double screenWidth) {
    final spacing = 12;
    final columnCount = getColumnCount(screenWidth);
    return (screenWidth - ((columnCount + 1) * spacing)) / columnCount;
  }

  buildBody() {
    return DynamicWidgetData(
      type: 'Container',
      properties: {
        'gradient': 'secondary',
      },
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'mainAxisSize': 'max'},
        children: [
          DynamicWidgetData(
            type: 'Container',
            properties: {
              'color': AppTheme.surface,
              'leftMargin': 16,
              'topMargin': 16,
              'rightMargin': 16,
              'radius': 16,
            },
            child: DynamicWidgetData(
              type: 'AppBar',
              properties: {
                'isBack': false,
                'isHome': false,
                'height': 80,
                'maxWidth': 1000,
                'titleColor': AppTheme.onPrimary,
                'leading': logoLabel(
                  subTitle: 'Admin Control Managment',
                  isMainAxisSize: 'min',
                ).toWidget(),
              },
            ),
          ),
          DynamicWidgetData(
            type: 'Expanded',
            child: DynamicWidgetData(
              type: 'Container',
              properties: {
                'color': AppTheme.background,
                'margin': 16,
                'padding': 16,
                'radius': 16,
                'height': double.infinity,
                'width': double.infinity,
              },
              child: DynamicWidgetData(
                type: 'Column',
                properties: {
                  'mainAxisSize': 'max',
                  'mainAxisAlignment': 'start',
                  'crossAxisAlignment': 'stretch',
                },
                children: [
                  DynamicWidgetData(
                    type: 'Container',
                    properties: {
                      'width': double.infinity,
                    },
                    child: DynamicWidgetData(
                      type: 'Wrap',
                      properties: {
                        'spacing': 12,
                        'runSpacing': 12,
                        'aspectRatio': 2.5,
                      },
                      children: texts.map((text) {
                        return DynamicWidgetData(
                          type: 'Container',
                          properties: {
                            'minWidth': 100,
                            'maxWidth': getItemWidth(screenWidth),
                            'color': AppTheme.onSecondary,
                          },
                          child: DynamicWidgetData(
                            type: 'Text',
                            properties: {
                              'text': text,
                              'style': {'fontSize': 16}
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  DynamicWidgetData(type: 'Text'),
                ],
              ),
            ),
          ),
        ],
      ),
    ).toWidget();
  }
}
