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
  List<dynamic> platformManage = [
    {
      'title': 'Platform Screens',
      'subTitle': 'Manage and edit StartFront UI screens',
    },
    'Navigation Menus',
    'Widget Management',
    'Widget Presets',
    'Global Theme',
    'Roles & Permissions'
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

  double getItemWidth(double screenWidth) {
    final spacing = 12;
    return (screenWidth - ((5 + 1) * spacing)) / 5;
  }

  double getManageWidth(double screenWidth) {
    final spacing = 12;
    return (screenWidth - ((4 + 1) * spacing)) / 4;
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
                                    AppTheme.onSurface.withOpacity(0.15),
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
                        // SvgPicture.asset(
                        //   'assets/my_icon.svg',
                        //   width: 32,
                        //   height: 32,
                        // ),
                        DynamicWidgetData(
                          type: 'SvgImage',
                          properties: {
                            'width': 100,
                            'height': 100,
                            'image': 'assets/svg/activity-circle.svg',
                          },
                        ),
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
                                    AppTheme.onSurface.withOpacity(0.15),
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
                                    AppTheme.onSurface.withOpacity(0.15),
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
