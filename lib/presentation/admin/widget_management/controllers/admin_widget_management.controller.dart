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
  List<dynamic> widgets = [
    {
      'title': 'Button',
      'subTitle': 'A clickable button with elevation and hover effects',
      'type': 'Control',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'Text',
      'subTitle': 'A customizable text element with styling options',
      'type': 'Dispaly',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'TextField',
      'subTitle': 'An input field for text entry with validation',
      'type': 'Input',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
  ];
  List<dynamic> editWidgets = [
    {
      'icon': 'assets/svg/code.svg',
    },
    {
      'icon': 'assets/svg/settings.svg',
    },
    {
      'icon': 'assets/svg/copy.svg',
    },
    {
      'icon': 'assets/svg/edit.svg',
    },
    {
      'icon': 'assets/svg/delete.svg',
    },
  ];

  double getItemWidth(double screenWidth) {
    final spacing = 12;
    return (screenWidth - ((5 + 1) * spacing)) / 5;
  }

  // TODO: create layout component to check phone size cannot use

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
                      'borderColor': AppTheme.onSurface,
                      'borderWidth': 1,
                      'title': 'Create Widget',
                      'svgIcon': 'assets/svg/add.svg',
                      'svgIconColor': AppTheme.onPrimary,
                      'color': AppTheme.primary,
                      'textColor': AppTheme.onPrimary,
                      'horizontalPadding': 16,
                      'verticalPadding': 8,
                      'radius': 8,
                      'fontSize': 14,
                      'iconSize': 18,
                      'action': () {
                        DynamicWidgetData(
                          type: 'Alert',
                          properties: {
                            
                            'title': 'Fill Info',
                            'content':
                                DynamicWidgetData(type: 'Column', properties: {
                              'mainAxisSize': 'min',
                            }, children: [
                              DynamicWidgetData(
                                  type: 'Text',
                                  properties: {'text': 'Enter your email'}),
                              DynamicWidgetData(
                                  type: 'TextField',
                                  properties: {'controllerKey': 'emailField'}),
                            ]),
                            'confirmText': 'Submit',
                            'onConfirm': () {
                              final email = Get.find<TextEditingController>(
                                      tag: 'emailField')
                                  .text;
                              print('Email: $email');
                            },
                          },
                        ).toWidget();
                      },
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
                        'spacing': 32,
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
                        // NOTE: all widgets
                        DynamicWidgetData(
                          type: 'Container',
                          properties: {
                            'maxWidth': 1280,
                            'color': AppTheme.onSecondary,
                            'radius': 16,
                            'borderWidth': 1,
                            'borderColor': AppTheme.onSurface.withOpacity(0.15),
                          },
                          child: DynamicWidgetData(
                            type: 'Column',
                            properties: {},
                            children: [
                              DynamicWidgetData(
                                type: 'Container',
                                properties: {
                                  'padding': 24,
                                },
                                child: DynamicWidgetData(
                                  type: 'Text',
                                  properties: {
                                    'text': 'All Widgets',
                                    'fontSize': 17,
                                    'fontWeight': 'bold',
                                    'color': AppTheme.onSurface,
                                  },
                                ),
                              ),
                              DynamicWidgetData(
                                type: 'FlexibleWrap',
                                properties: {},
                                children: widgets.map((item) {
                                  return DynamicWidgetData(
                                    type: 'Column',
                                    properties: {},
                                    children: [
                                      DynamicWidgetData(
                                        type: 'Container',
                                        properties: {
                                          'height': 0.5,
                                          'width': double.infinity,
                                          'color':
                                              AppTheme.onSurface.withAlpha(80),
                                        },
                                      ),
                                      DynamicWidgetData(
                                        type: 'Container',
                                        properties: {
                                          'maxWidth': 1280,
                                          'color': AppTheme.onSecondary,
                                          'padding': 24,
                                          'radius': 16,
                                        },
                                        child: DynamicWidgetData(
                                          type: 'Row',
                                          properties: {
                                            'mainAxisAlignment': 'spaceBetween',
                                          },
                                          children: [
                                            DynamicWidgetData(
                                              type: 'Row',
                                              properties: {
                                                'spacing': 16,
                                              },
                                              children: [
                                                DynamicWidgetData(
                                                  type: 'Container',
                                                  properties: {
                                                    'color': Colors.blueAccent
                                                        .withOpacity(0.2),
                                                    'padding': 8,
                                                    'radius': 8,
                                                  },
                                                  child: DynamicWidgetData(
                                                    type: 'SvgImage',
                                                    properties: {
                                                      'width': 24,
                                                      'height': 24,
                                                      'image':
                                                          'assets/svg/widget-manage.svg',
                                                      'color': Colors
                                                          .blueAccent.shade700,
                                                    },
                                                  ),
                                                ),
                                                DynamicWidgetData(
                                                  type: 'Column',
                                                  properties: {
                                                    'mainAxisSize': 'min',
                                                  },
                                                  children: [
                                                    DynamicWidgetData(
                                                      type: 'Text',
                                                      properties: {
                                                        'text': item['title'],
                                                        'fontSize': 16,
                                                        'fontWeight': 'bold',
                                                        'color':
                                                            AppTheme.onSurface,
                                                      },
                                                    ),
                                                    DynamicWidgetData(
                                                      type: 'Text',
                                                      properties: {
                                                        'text':
                                                            item['subTitle'],
                                                        'color':
                                                            AppTheme.secondary,
                                                      },
                                                    ),
                                                    DynamicWidgetData(
                                                        type: 'SizedBox',
                                                        properties: {
                                                          'height': 6
                                                        }),
                                                    DynamicWidgetData(
                                                      type: 'Row',
                                                      properties: {
                                                        'crossAxisAlignment':
                                                            'center',
                                                        'spacing': 8,
                                                      },
                                                      children: [
                                                        DynamicWidgetData(
                                                          type: 'Container',
                                                          properties: {
                                                            'verticalPadding':
                                                                4,
                                                            'horizontalPadding':
                                                                8,
                                                            'radius': 6,
                                                            'color': AppTheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.11),
                                                          },
                                                          child:
                                                              DynamicWidgetData(
                                                            type: 'Text',
                                                            properties: {
                                                              'text':
                                                                  item['type'],
                                                              'fontSize': 12,
                                                              'color': AppTheme
                                                                  .secondary,
                                                            },
                                                          ),
                                                        ),
                                                        DynamicWidgetData(
                                                          type: 'Text',
                                                          properties: {
                                                            'text':
                                                                '${item['propertiesCount']} properties',
                                                            'fontSize': 12,
                                                            'color': AppTheme
                                                                .secondary,
                                                          },
                                                        ),
                                                        DynamicWidgetData(
                                                          type: 'Text',
                                                          properties: {
                                                            'text':
                                                                '${item['functionCount']} functions',
                                                            'fontSize': 12,
                                                            'color': AppTheme
                                                                .secondary,
                                                          },
                                                        ),
                                                        DynamicWidgetData(
                                                          type: 'Text',
                                                          properties: {
                                                            'text':
                                                                'Updated ${item['updated_at']}',
                                                            'fontSize': 12,
                                                            'color': AppTheme
                                                                .secondary,
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            DynamicWidgetData(
                                              type: 'RowList',
                                              properties: {
                                                'spacing': 12,
                                              },
                                              children: editWidgets.map((item) {
                                                return DynamicWidgetData(
                                                  type: 'Button',
                                                  properties: {
                                                    'isButton': true,
                                                    'svgIcon': item['icon'],
                                                    'svgIconColor':
                                                        AppTheme.onBackground,
                                                    'hoverSvgIconColor':
                                                        AppTheme.onPrimary,
                                                    'padding': 8,
                                                    'radius': 8,
                                                    'fontSize': 14,
                                                    'iconSize': 18,
                                                    'action': () =>
                                                        print('Create Widget'),
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
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
