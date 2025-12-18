import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../domain/service/dynamic_service.dart';
import '../../../../domain/service/handle_error.dart';
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
      'icon': IconsaxPlusLinear.grid_7,
      'color': Colors.blue,
      'route': '/admin-platforms-screens',
    },
    {
      'title': 'Navigation Menus',
      'subTitle': 'Configure plaform navigation',
      'icon': IconsaxPlusLinear.menu,
      'color': Colors.green,
      'route': '/',
    },
    {
      'title': 'Widget Management',
      'subTitle': 'Create and manage custom widgets',
      'icon': IconsaxPlusLinear.box,
      'color': Colors.deepPurpleAccent,
      'route': '/admin-widget-management',
    },
    {
      'title': 'Widget Presets',
      'subTitle': 'Manage reusable widget combinations',
      'icon': IconsaxPlusLinear.layer,
      'color': Colors.purpleAccent,
      'route': '/',
    },
    {
      'title': 'Global Theme',
      'subTitle': 'Platfrom-wide styling and branding',
      'icon': IconsaxPlusLinear.brush_3,
      'color': Colors.pinkAccent,
      'route': '/',
    },
    {
      'title': 'Roles & Permissions',
      'subTitle': 'User access and security settings',
      'icon': IconsaxPlusLinear.shield,
      'color': Colors.red,
      'route': '/',
    },
  ];
  List<dynamic> clientManages = [
    {
      'title': 'Client Projects',
      'subTitle': 'Manage client accounts and projects',
      'icon': IconsaxPlusLinear.profile_2user,
      'color': Colors.indigoAccent,
      'route': '/',
    },
    {
      'title': 'Platform Analytics',
      'subTitle': 'View usage and performance metrics',
      'icon': IconsaxPlusBold.chart_1,
      'color': Colors.orange,
      'route': '/',
    },
    {
      'title': 'System Settings',
      'subTitle': 'Configure platform settings',
      'icon': IconsaxPlusLinear.setting_2,
      'color': Colors.blueGrey,
      'route': '/',
    },
  ];

  final DynamicService _dynamicService = DynamicService();

  // RxMap widgetPresets = {}.obs;
  // RxMap navigationItems = {}.obs;
  // RxMap navigationMenus = {}.obs;
  RxList widgetPresets = [].obs;
  RxList navigationItems = [].obs;
  RxList navigationMenus = [].obs;

  Future<void> _makeMultipleRequests() async {
    try {
      // Show loading before starting the requests
      EasyLoading.show(status: 'Loading...');

      // Call multiple API requests concurrently
      final call1 = _dynamicService.fetchDynamicData<Map<String, dynamic>>(
        name: 'Request 1',
        reqBody: {"msgId": "WIDGET_PRESET_ITEMS_list", "data": {}},
      );

      final call2 = _dynamicService.fetchDynamicData<Map<String, dynamic>>(
        name: 'Request 2',
        reqBody: {"msgId": "NAVIGATION_ITEMS_list", "data": {}},
      );

      final call3 = _dynamicService.fetchDynamicData<Map<String, dynamic>>(
        name: 'Request 3',
        reqBody: {"msgId": "NAVIGATION_MENUS_list", "data": {}},
      );

      // Wait for all requests to complete
      final results = await Future.wait([call1, call2, call3]);

      // Handle the responses
      bool errorOccurred = false; // Track if any error occurred

      for (var result in results) {
        result.fold((error) => errorOccurred = true, (data) {
          // Identify which request this is
          if (result == results[0]) {
            widgetPresets.value = data["data"] ?? [];
          } else if (result == results[1]) {
            navigationItems.value = data["data"] ?? [];
          } else if (result == results[2]) {
            navigationMenus.value = data["data"] ?? [];
          }
        });
      }

      // If any error occurred, show the error alert (only once)
      if (errorOccurred) {
        HandleError.errors(
          'ERROR_I_C',
          'Request Failed',
          'Some requests failed.',
        );
      }

      EasyLoading.dismiss();
    } catch (e) {
      // Handle unexpected errors
      EasyLoading.dismiss();
      HandleError.errors('ERROR_I_C', 'Unknown Error', e.toString());
    }
  }

  @override
  void onInit() async {
    await _makeMultipleRequests();
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
      properties: {'gradient': 'primary'},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'mainAxisSize': 'max', 'crossAxisAlignment': 'center'},
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
                      'hoverBorderColor': AppTheme.primary,
                      'color': AppTheme.surface,
                      'borderWidth': 1,
                      'hoverBorderWidth': 2,
                      'title': 'Logout',
                      'icon': IconsaxPlusBroken.logout,
                      'hoverIcon': IconsaxPlusLinear.logout,
                      'iconColor': AppTheme.onSurface,
                      'hoverIconColor': AppTheme.primary,
                      'textColor': AppTheme.onSurface,
                      'hoverTextColor': AppTheme.primary,
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
                    properties: {'width': 1280, 'padding': 16},
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
                          properties: {'spacing': 12, 'runSpacing': 12},
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
                                'borderColor': AppTheme.onSurface.withOpacity(
                                  0.15,
                                ),
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
                          properties: {'spacing': 12, 'runSpacing': 12},
                          children: platformManages.map((item) {
                            return DynamicWidgetData(
                              type: 'Container',
                              properties: {
                                'minWidth': 50,
                                'maxWidth': getManageWidth(1280),
                              },
                              child: DynamicWidgetData(
                                type: 'Button',
                                properties: {
                                  'radius': 16,
                                  'rippleColor': Colors.black26,
                                  'color': AppTheme.onSecondary,
                                  'width': double.infinity,
                                  'borderWidth': 1,
                                  'hoverBorderWidth': 2,
                                  'borderColor': AppTheme.onSurface.withOpacity(
                                    0.15,
                                  ),
                                  'hoverBorderColor': AppTheme.primary,
                                  'action': () => item['route'] != '/'
                                      ? Get.toNamed(item['route'])
                                      : null,
                                },
                                child: DynamicWidgetData(
                                  type: 'Container',
                                  properties: {'padding': 24, 'radius': 16},
                                  child: DynamicWidgetData(
                                    type: 'Row',
                                    properties: {
                                      'crossAxisAlignment': 'center',
                                      'spacing': 12,
                                    },
                                    children: [
                                      DynamicWidgetData(
                                        type: 'Container',
                                        properties: {
                                          'color': item['color'],
                                          'padding': 12,
                                          'radius': 12,
                                        },
                                        child: DynamicWidgetData(
                                          type: 'Icon',
                                          properties: {
                                            'size': 24,
                                            'icon': item['icon'],
                                            'color': AppTheme.onPrimary,
                                          },
                                        ),
                                      ),
                                      DynamicWidgetData(
                                        type: 'Flexible',
                                        child: DynamicWidgetData(
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
                                                'softWrap': true,
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                          properties: {'spacing': 12, 'runSpacing': 12},
                          children: clientManages.map((item) {
                            return DynamicWidgetData(
                              type: 'Container',
                              properties: {
                                'minWidth': 50,
                                'maxWidth': getManageWidth(1280),
                              },
                              child: DynamicWidgetData(
                                type: 'Button',
                                properties: {
                                  'radius': 16,
                                  'rippleColor': Colors.black26,
                                  'color': AppTheme.onSecondary,
                                  'width': double.infinity,
                                  'borderWidth': 1,
                                  'hoverBorderWidth': 2,
                                  'borderColor': AppTheme.onSurface.withOpacity(
                                    0.15,
                                  ),
                                  'hoverBorderColor': AppTheme.primary,
                                  'action': () => item['route'] != '/'
                                      ? Get.toNamed(item['route'])
                                      : null,
                                },
                                child: DynamicWidgetData(
                                  type: 'Container',
                                  properties: {'padding': 24, 'radius': 16},
                                  child: DynamicWidgetData(
                                    type: 'Row',
                                    properties: {
                                      'crossAxisAlignment': 'center',
                                      'spacing': 12,
                                    },
                                    children: [
                                      DynamicWidgetData(
                                        type: 'Container',
                                        properties: {
                                          'color': item['color'],
                                          'padding': 12,
                                          'radius': 12,
                                        },
                                        child: DynamicWidgetData(
                                          type: 'Icon',
                                          properties: {
                                            'size': 24,
                                            'icon': item['icon'],
                                            'color': AppTheme.onPrimary,
                                          },
                                        ),
                                      ),
                                      DynamicWidgetData(
                                        type: 'Flexible',
                                        child: DynamicWidgetData(
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
                                                'softWrap': true,
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
