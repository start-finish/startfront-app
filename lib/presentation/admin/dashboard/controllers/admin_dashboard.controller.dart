import 'package:flutter/material.dart';
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
  List<dynamic> platformManages = [
    {
      'title': 'Platform Screens',
      'subTitle': 'Manage and edit StartFront UI screens',
      'icon': 'assets/svg/platform.svg',
      'color': Colors.blue,
    },
    {
      'title': 'Navigation Menus',
      'subTitle': 'Configure plaform navigation',
      'icon': 'assets/svg/navigation.svg',
      'color': Colors.green,
    },
    {
      'title': 'Widget Management',
      'subTitle': 'Create and manage custom widgets',
      'icon': 'assets/svg/widget-manage.svg',
      'color': Colors.deepPurpleAccent,
    },
    {
      'title': 'Widget Presets',
      'subTitle': 'Manage reusable widget combinations',
      'icon': 'assets/svg/widget-presets.svg',
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Global Theme',
      'subTitle': 'Platfrom-wide styling and branding',
      'icon': 'assets/svg/theme.svg',
      'color': Colors.pinkAccent,
    },
    {
      'title': 'Roles & Permissions',
      'subTitle': 'User access and security settings',
      'icon': 'assets/svg/role-permission.svg',
      'color': Colors.red,
    },
  ];
  List<dynamic> clientManages = [
    {
      'title': 'Client Projects',
      'subTitle': 'Manage client accounts and projects',
      'icon': 'assets/svg/users-group.svg',
      'color': Colors.indigoAccent,
    },
    {
      'title': 'Platform Analytics',
      'subTitle': 'View usage and performance metrics',
      'icon': 'assets/svg/analytic.svg',
      'color': Colors.orange,
    },
    {
      'title': 'System Settings',
      'subTitle': 'Configure platform settings',
      'icon': 'assets/svg/settings.svg',
      'color': Colors.blueGrey,
    },
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

  bool isHovered = false;

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
                'isBack': false,
                'isHome': false,
                'height': 80,
                'maxWidth': 1280,
                'titleColor': AppTheme.onPrimary,
                'leading': logoLabel(
                  subTitle: 'Admin Control Managment',
                  isMainAxisSize: 'min',
                ).toWidget(),
                'action': [
                  DynamicWidgetData(
                    type: 'Button',
                    properties: {
                      'rippleColor': Colors.black26,
                      'borderColor': AppTheme.onSurface,
                      'borderWidth': 1,
                      'title': 'Logout',
                      'svgIcon': 'assets/svg/log-out.svg',
                      'svgIconColor': AppTheme.onSurface,
                      'color': Colors.white,
                      'textColor': Colors.black,
                      'horizontalPadding': 16,
                      'verticalPadding': 8,
                      'radius': 8,
                      'fontSize': 14,
                      'iconSize': 18,
                      'action': () => Get.offAllNamed('/login'),
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
                          type: 'FlexibleWrap',
                          properties: {
                            'spacing': 12,
                            'runSpacing': 12,
                          },
                          children: platformManages.map((item) {
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
                                type: 'Button',
                                properties: {
                                  'isHover': isHovered,
                                  'action': () => null,
                                },
                                child: DynamicWidgetData(
                                  type: 'Row',
                                  properties: {
                                    'mainAxisSize': 'min',
                                    'crossAxisAlignment': 'center',
                                    'spacing': 12,
                                  },
                                  children: [
                                    DynamicWidgetData(
                                      type: 'Container',
                                      properties: {
                                        'color': item['color'],
                                        'padding': 8,
                                        'radius': 8,
                                      },
                                      child: DynamicWidgetData(
                                        type: 'SvgImage',
                                        properties: {
                                          'isHover': isHovered,
                                          'width': isHovered == true ? 32 : 24,
                                          'height': isHovered == true ? 32 : 24,
                                          'image': item['icon'],
                                          'color': AppTheme.onPrimary,
                                        },
                                      ),
                                    ),
                                    DynamicWidgetData(
                                      type: 'Column',
                                      properties: {
                                        'mainAxisAlignment': 'center',
                                      },
                                      children: [
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': item['title'],
                                            'fontWeight': 'w600',
                                            'fontSize': 16,
                                            'color': AppTheme.secondary,
                                          },
                                        ),
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': item['subTitle'],
                                            'color': AppTheme.secondary,
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                          type: 'FlexibleWrap',
                          properties: {
                            'spacing': 12,
                            'runSpacing': 12,
                          },
                          children: clientManages.map((item) {
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
                                type: 'Row',
                                properties: {
                                  'mainAxisSize': 'min',
                                  'crossAxisAlignment': 'center',
                                  'spacing': 12,
                                },
                                children: [
                                  DynamicWidgetData(
                                    type: 'Container',
                                    properties: {
                                      'color': item['color'],
                                      'padding': 8,
                                      'radius': 8,
                                    },
                                    child: DynamicWidgetData(
                                      type: 'SvgImage',
                                      properties: {
                                        'width': 24,
                                        'height': 24,
                                        'image': item['icon'],
                                        'color': AppTheme.onPrimary,
                                      },
                                    ),
                                  ),
                                  DynamicWidgetData(
                                    type: 'Column',
                                    properties: {
                                      'mainAxisAlignment': 'center',
                                    },
                                    children: [
                                      DynamicWidgetData(
                                        type: 'Text',
                                        properties: {
                                          'text': item['title'],
                                          'fontWeight': 'w600',
                                          'fontSize': 16,
                                          'color': AppTheme.secondary,
                                        },
                                      ),
                                      DynamicWidgetData(
                                        type: 'Text',
                                        properties: {
                                          'text': item['subTitle'],
                                          'color': AppTheme.secondary,
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
