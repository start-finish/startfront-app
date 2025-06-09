import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/data/data.dart';

class AdminWidgetManagementController extends GetxController {
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

  List<String> texts = [
    'Total Widgets',
    'Control Widgets',
    'Input Widgets',
    'Layout Widgets',
  ];

  double getItemWidth(double screenWidth) {
    final spacing = 12;
    return (screenWidth - ((5 + 1) * spacing)) / 5;
  }

  buildBody() {
    return DynamicWidgetData(
      type: 'Container',
      properties: {
        'gradient': 'primary',
      },
      child: DynamicWidgetData(
        type: 'Column',
        properties: {
          'mainAxisSize': 'max',
          'crossAxisAlignment': 'center',
        },
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
                'isHome': false,
                'height': 80,
                'maxWidth': double.infinity,
                'titleColor': AppTheme.onSurface,
                'subTitleColor': AppTheme.onSurface,
                'title': 'Widget Management',
                'subTitle': 'Create and manage custom widgets',
                'action': [
                  DynamicWidgetData(
                    type: 'Button',
                    properties: {
                      'rippleColor': Colors.black26,
                      'borderColor': AppTheme.onSurface,
                      'borderWidth': 1,
                      'title': 'Create Widget',
                      'svgIcon': 'assets/svg/add.svg',
                      'svgIconColor': AppTheme.onSurface,
                      'color': Colors.white,
                      'textColor': Colors.black,
                      'horizontalPadding': 16,
                      'verticalPadding': 8,
                      'radius': 8,
                      'fontSize': 14,
                      'iconSize': 18,
                      'action': () => print('Create Widget'),
                    },
                  ),
                ],
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
                'radius': 16,
                'height': double.infinity,
              },
              child: DynamicWidgetData(
                type: 'Scroll',
                properties: {},
                child: DynamicWidgetData(
                  type: 'Center',
                  child: DynamicWidgetData(
                    type: 'Container',
                    properties: {
                      'width': 1280,
                      'padding': 16,
                    },
                    child: DynamicWidgetData(
                      type: 'Column',
                      properties: {
                        'mainAxisSize': 'max',
                        'mainAxisAlignment': 'start',
                        'spacing': 18,
                      },
                      children: [
                        DynamicWidgetData(
                          type: 'FlexibleWrap',
                          properties: {
                            'spacing': 12,
                            'runSpacing': 12,
                          },
                          children: texts.map((text) {
                            return DynamicWidgetData(
                              type: 'Container',
                              properties: {
                                'minWidth': 50,
                                'maxWidth': getItemWidth(1280),
                                'color': AppTheme.onSecondary,
                                'padding': 24,
                                'radius': 16,
                                'borderWidth': 1,
                                'borderColor':
                                    AppTheme.onSurface.withOpacity(0.15),
                              },
                              child: DynamicWidgetData(
                                type: 'Column',
                                properties: {
                                  'mainAxisSize': 'min',
                                },
                                children: [
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': '22',
                                      'fontSize': 22,
                                      'fontWeight': 'bold',
                                      'color': AppTheme.onSurface,
                                    },
                                  ),
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': text,
                                      'color': AppTheme.secondary,
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).toWidget();
  }
}
