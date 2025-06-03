import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/component/logo_label.dart';
import '../../../dynamic/data/data.dart';

class AdminDashboardController extends GetxController {
  List<String> texts = [
    'Platform Screens',
    'Active Clients',
    'Widget Presets',
    'Total Users',
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

  int getColumnCount(double width) {
    if (width <= 600) return 1;
    if (width <= 1280) return 4;
    return 3;
  }

  double getItemWidth(double screenWidth) {
    final spacing = 12;
    final columnCount = getColumnCount(screenWidth);
    return (screenWidth - ((columnCount + 1) * spacing)) / columnCount;
  }

  int getManageCount(double width) {
    if (width <= 600) return 1;
    if (width <= 1280) return 3;
    return 2;
  }

  double getManageWidth(double screenWidth) {
    final spacing = 12;
    final columnCount = getManageCount(screenWidth);
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
                'isBack': false,
                'isHome': false,
                'height': 80,
                'maxWidth': 1280,
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
                      'verticalPadding': 16,
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
                          type: 'Wrap',
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
                                    AppTheme.onSurface.withOpacity(0.3),
                              },
                              child: DynamicWidgetData(
                                type: 'Column',
                                properties: {
                                  'mainAxisSize': 'min',
                                  'spacing': 12,
                                },
                                children: [
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': text,
                                      'fontWeight': 'w600',
                                      'color': AppTheme.secondary,
                                    },
                                  ),
                                  DynamicWidgetData(
                                    type: 'Row',
                                    properties: {
                                      'crossAxisAlignment': 'center',
                                      'spacing': 8,
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
                                          'text': '+1 this week',
                                          'color': AppTheme.primary,
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        // NOTE: platform management
                        DynamicWidgetData(
                          type: 'SizedBox',
                          properties: {'height': 8},
                        ),
                        DynamicWidgetData(
                          type: 'Text',
                          properties: {
                            'text': 'Platform Management',
                            'fontSize': 18,
                            'fontWeight': 'bold',
                          },
                        ),
                        DynamicWidgetData(
                          type: 'Text',
                          properties: {
                            'text':
                                'Manage StartFront\'s own UI and functionality',
                          },
                        ),
                        DynamicWidgetData(
                          type: 'Wrap',
                          properties: {
                            'spacing': 12,
                            'runSpacing': 12,
                          },
                          children: texts.map((text) {
                            return DynamicWidgetData(
                              type: 'Container',
                              properties: {
                                'minWidth': 50,
                                'maxWidth': getManageWidth(1280),
                                'color': AppTheme.onSecondary,
                                'padding': 24,
                                'radius': 16,
                                'borderWidth': 1,
                                'borderColor':
                                    AppTheme.onSurface.withOpacity(0.3),
                              },
                              child: DynamicWidgetData(
                                type: 'Column',
                                properties: {
                                  'mainAxisSize': 'min',
                                  'spacing': 12,
                                },
                                children: [
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': text,
                                      'fontWeight': 'w600',
                                      'color': AppTheme.secondary,
                                    },
                                  ),
                                  DynamicWidgetData(
                                    type: 'Row',
                                    properties: {
                                      'crossAxisAlignment': 'center',
                                      'spacing': 8,
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
                                          'text': '+1 this week',
                                          'color': AppTheme.primary,
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        // NOTE: client management
                        DynamicWidgetData(
                          type: 'SizedBox',
                          properties: {'height': 8},
                        ),
                        DynamicWidgetData(
                          type: 'Text',
                          properties: {
                            'text': 'Client Management',
                            'fontSize': 18,
                            'fontWeight': 'bold',
                          },
                        ),
                        DynamicWidgetData(
                          type: 'Text',
                          properties: {
                            'text':
                                'Manage client projects and platform operations',
                          },
                        ),
                        DynamicWidgetData(
                          type: 'Wrap',
                          properties: {
                            'spacing': 12,
                            'runSpacing': 12,
                          },
                          children: texts.map((text) {
                            return DynamicWidgetData(
                              type: 'Container',
                              properties: {
                                'minWidth': 50,
                                'maxWidth': getManageWidth(1280),
                                'color': AppTheme.onSecondary,
                                'padding': 24,
                                'radius': 16,
                                'borderWidth': 1,
                                'borderColor':
                                    AppTheme.onSurface.withOpacity(0.3),
                              },
                              child: DynamicWidgetData(
                                type: 'Column',
                                properties: {
                                  'mainAxisSize': 'min',
                                  'spacing': 12,
                                },
                                children: [
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': text,
                                      'fontWeight': 'w600',
                                      'color': AppTheme.secondary,
                                    },
                                  ),
                                  DynamicWidgetData(
                                    type: 'Row',
                                    properties: {
                                      'crossAxisAlignment': 'center',
                                      'spacing': 8,
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
                                          'text': '+1 this week',
                                          'color': AppTheme.primary,
                                        },
                                      ),
                                    ],
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
