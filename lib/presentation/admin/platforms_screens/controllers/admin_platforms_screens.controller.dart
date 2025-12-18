import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/data/data.dart';

class AdminPlatformsScreensController extends GetxController {
  final searchTF = TextEditingController();
  final searchFN = FocusNode();

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
    int count = 4;

    if (screenWidth < 1180) {
      count = 3;
    }
    if (screenWidth >= 1180) {
      count = 4;
    }

    return (screenWidth - ((count + 1) * spacing)) / count;
  }

  RxList<Map<String, dynamic>> screens = <Map<String, dynamic>>[
    {
      'title': 'Dashboard',
      'route': '/dashboard',
      'icon': 'assets/svg/platform.svg',
      'type': 'Main',
      'desc': 'Main dashboard screen for the platform',
      'modifed': '2 hours ago',
      'status': '1',
    },
    {
      'title': 'Dashboard',
      'route': '/dashboard',
      'icon': 'assets/svg/platform.svg',
      'type': 'Main',
      'desc': 'Main dashboard screen for the platform',
      'modifed': '2 hours ago',
      'status': '2',
    },
    {
      'title': 'Dashboard',
      'route': '/dashboard',
      'icon': 'assets/svg/platform.svg',
      'type': 'Main',
      'desc': 'Main dashboard screen for the platform',
      'modifed': '2 hours ago',
      'status': '2',
    },
    {
      'title': 'Dashboard',
      'route': '/dashboard',
      'icon': 'assets/svg/platform.svg',
      'type': 'Main',
      'desc': 'Main dashboard screen for the platform',
      'modifed': '2 hours ago',
      'status': '1',
    },
  ].obs;

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
                'title': 'Platform Screens',
                'subTitle': 'Manage and edit StartFront UI screens',
                'action': [
                  DynamicWidgetData(
                    type: 'Button',
                    properties: {
                      'borderWidth': 1,
                      'hoverBorderWidth': 2,
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
                        'mainAxisSize': 'min',
                        'mainAxisAlignment': 'start',
                        'spacing': 32,
                      },
                      children: [
                        DynamicWidgetData(
                          type: 'Row',
                          properties: {
                            'mainAxisSize': 'max',
                            'mainAxisAlignment': 'spaceBetween',
                            'crossAxisAlignment': 'center',
                          },
                          children: [
                            DynamicWidgetData(
                              type: 'Row',
                              properties: {
                                'mainAxisSize': 'min',
                                'spacing': 16,
                              },
                              children: [
                                DynamicWidgetData(
                                  type: 'Container',
                                  properties: {
                                    'width': 250,
                                  },
                                  child: DynamicWidgetData(
                                    type: 'TextField',
                                    properties: {
                                      'prefixIcon': Icons.search_rounded,
                                      'controller': searchTF,
                                      'focusNode': searchFN,
                                      'hintText': 'Search screens...',
                                      'isRequired': false.obs,
                                      'errorText': '',
                                      'showError': false.obs,
                                      'borderColor':
                                          AppTheme.onSurface.withOpacity(0.3),
                                    },
                                  ),
                                ),
                                DynamicWidgetData(
                                  type: 'Dropdown',
                                  properties: {
                                    'width': 80,
                                    'items': [
                                      'All Status',
                                      'Published',
                                      'Draft',
                                    ],
                                    'svgIcon': 'assets/svg/filter.svg',
                                    'hintText': 'All Status',
                                    'controllerKey': 'dropdown_color',
                                    'initialValue': 'All Status',
                                    'onChanged': (value) {
                                      print('Selected: $value');
                                    },
                                    'backgroundColor': 0xFFFFFFFF,
                                    'borderColor': 0xFFCCCCCC,
                                    'borderWidth': 1.0,
                                    'radius': 12,
                                    'enableSearch': false,
                                  },
                                ),
                              ],
                            ),
                            DynamicWidgetData(
                              type: 'Column',
                              properties: {
                                'crossAxisAlignment': 'end',
                                'spacing': 6,
                              },
                              children: [
                                DynamicWidgetData(
                                  type: 'Text',
                                  properties: {
                                    'text': '${screens.length} screens found',
                                    'fontSize': 15,
                                    'fontWeight': 'bold',
                                    'color': AppTheme.secondary,
                                  },
                                ),
                                DynamicWidgetData(
                                  type: 'Row',
                                  properties: {
                                    'mainAxisSize': 'min',
                                    'mainAxisAlignment': 'center',
                                    'crossAxisAlignment': 'center',
                                    'spacing': 12,
                                  },
                                  children: [
                                    DynamicWidgetData(
                                      type: 'Row',
                                      properties: {
                                        'mainAxisSize': 'min',
                                        'mainAxisAlignment': 'center',
                                        'crossAxisAlignment': 'center',
                                        'spacing': 4,
                                      },
                                      children: [
                                        DynamicWidgetData(
                                          type: 'Container',
                                          properties: {
                                            'color':
                                                AppTheme.primary.withAlpha(100),
                                            'verticalPadding': 1,
                                            'horizontalPadding': 8,
                                            'radius': 12,
                                          },
                                          child: DynamicWidgetData(
                                            type: 'Text',
                                            properties: {
                                              'text': '3',
                                              'fontSize': 12,
                                              'fontWeight': 'bold',
                                              'color': AppTheme.secondary,
                                            },
                                          ),
                                        ),
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': 'Published',
                                            'fontSize': 12,
                                            'color': AppTheme.secondary,
                                          },
                                        ),
                                      ],
                                    ),
                                    DynamicWidgetData(
                                      type: 'Row',
                                      properties: {
                                        'mainAxisSize': 'min',
                                        'mainAxisAlignment': 'center',
                                        'crossAxisAlignment': 'center',
                                        'spacing': 4,
                                      },
                                      children: [
                                        DynamicWidgetData(
                                          type: 'Container',
                                          properties: {
                                            'color': AppTheme.onBackground
                                                .withAlpha(30),
                                            'verticalPadding': 1,
                                            'horizontalPadding': 8,
                                            'radius': 12,
                                          },
                                          child: DynamicWidgetData(
                                            type: 'Text',
                                            properties: {
                                              'text': '1',
                                              'fontSize': 12,
                                              'fontWeight': 'bold',
                                              'color': AppTheme.secondary,
                                            },
                                          ),
                                        ),
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': 'Draft',
                                            'fontSize': 12,
                                            'color': AppTheme.secondary,
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // NOTE: all widgets
                        DynamicWidgetData(
                          type: 'Container',
                          properties: {
                            'maxWidth': 1280,
                          },
                          child: DynamicWidgetData(
                            type: 'FlexibleWrap',
                            properties: {
                              'spacing': 24,
                              'runSpacing': 24,
                            },
                            children: screens.map((item) {
                              return DynamicWidgetData(
                                type: 'Container',
                                properties: {
                                  'maxWidth': getItemWidth(1280),
                                  'color': AppTheme.onSecondary,
                                  'radius': 16,
                                  'borderWidth': 0.7,
                                  'borderColor':
                                      AppTheme.onSurface.withOpacity(0.25),
                                },
                                child: DynamicWidgetData(
                                  type: 'Column',
                                  properties: {
                                    'mainAxisSize': 'min',
                                  },
                                  children: [
                                    DynamicWidgetData(
                                      type: 'Container',
                                      properties: {
                                        'height': 120,
                                        'width': double.infinity,
                                        'gradient': 'totery',
                                        'radiusTopLeft': 15,
                                        'radiusTopRight': 15,
                                      },
                                      child: DynamicWidgetData(
                                        type: 'Column',
                                        properties: {
                                          'mainAxisAlignment': 'center',
                                          'crossAxisAlignment': 'center',
                                          'spacing': 8,
                                        },
                                        children: [
                                          DynamicWidgetData(
                                            type: 'SvgImage',
                                            properties: {
                                              'image': item['icon'],
                                              'color': AppTheme.onBackground
                                                  .withAlpha(200),
                                              'width': 32,
                                              'height': 32,
                                            },
                                          ),
                                          DynamicWidgetData(
                                            type: 'Column',
                                            properties: {
                                              'mainAxisAlignment': 'center',
                                              'crossAxisAlignment': 'center',
                                            },
                                            children: [
                                              DynamicWidgetData(
                                                type: 'Text',
                                                properties: {
                                                  'text': '${item['title']}',
                                                  'fontWeight': 'bold',
                                                },
                                              ),
                                              DynamicWidgetData(
                                                type: 'Text',
                                                properties: {
                                                  'text': '${item['route']}',
                                                  'fontSize': 12,
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DynamicWidgetData(
                                      type: 'Container',
                                      properties: {
                                        'padding': 16,
                                      },
                                      child: DynamicWidgetData(
                                        type: 'Column',
                                        properties: {
                                          'spacing': 12,
                                          'mainAxisSize': 'min'
                                        },
                                        children: [
                                          DynamicWidgetData(
                                            type: 'Row',
                                            properties: {
                                              'mainAxisSize': 'max',
                                              'mainAxisAlignment':
                                                  'spaceBetween',
                                              'crossAxisAlignment': 'center',
                                            },
                                            children: [
                                              DynamicWidgetData(
                                                type: 'Column',
                                                properties: {},
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
                                                      'text': item['type'],
                                                      'fontSize': 15,
                                                      'color':
                                                          AppTheme.secondary,
                                                    },
                                                  ),
                                                ],
                                              ),
                                              // NOTE: status button
                                              DynamicWidgetData(
                                                type: 'Button',
                                                properties: {
                                                  'title': item['status'] == '1'
                                                      ? 'Published'
                                                      : 'Draft',
                                                  'fontSize': 12,
                                                  'textColor':
                                                      AppTheme.onPrimary,
                                                  'radius': 30,
                                                  'horizontalPadding': 18,
                                                  'verticalPadding': 6,
                                                  'borderColor':
                                                      item['status'] == '1'
                                                          ? AppTheme.success
                                                          : AppTheme
                                                              .onBackground,
                                                  'color': item['status'] == '1'
                                                      ? AppTheme.success
                                                      : AppTheme.onBackground,
                                                  'action': () {
                                                    final index =
                                                        screens.indexOf(item);
                                                    if (index != -1) {
                                                      final currentStatus =
                                                          screens[index]
                                                              ['status'];
                                                      screens[index]['status'] =
                                                          currentStatus == '1'
                                                              ? '2'
                                                              : '1';
                                                      screens.refresh();
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          DynamicWidgetData(
                                            type: 'Text',
                                            properties: {
                                              'text': item['desc'],
                                              'color': AppTheme.secondary,
                                              'fontSize': 12,
                                            },
                                          ),
                                          DynamicWidgetData(
                                            type: 'Text',
                                            properties: {
                                              'text':
                                                  'Modified ${item['modifed']}',
                                              'color': AppTheme.secondary,
                                              'fontSize': 12,
                                            },
                                          ),
                                          DynamicWidgetData(
                                            type: 'Container',
                                            properties: {
                                              'height': 40,
                                            },
                                            child: DynamicWidgetData(
                                              type: 'Row',
                                              properties: {
                                                'mainAxisSize': 'max',
                                                'mainAxisAlignment':
                                                    'spaceBetween',
                                                'crossAxisAlignment': 'center',
                                                'spacing': 12,
                                              },
                                              children: [
                                                // NOTE: edit button
                                                DynamicWidgetData(
                                                  type: 'Button',
                                                  properties: {
                                                    'isExpanded': true,
                                                    'hoverBorderWidth': 2,
                                                    'rippleColor':
                                                        Colors.black26,
                                                    'color': AppTheme.primary,
                                                    'borderWidth': 1,
                                                    'title': 'Edit',
                                                    'svgIcon':
                                                        'assets/svg/edit.svg',
                                                    'svgIconColor':
                                                        AppTheme.onPrimary,
                                                    'hoverSvgIconColor':
                                                        AppTheme.onPrimary,
                                                    'textColor':
                                                        AppTheme.onPrimary,
                                                    'hoverTextColor':
                                                        AppTheme.onPrimary,
                                                    'horizontalPadding': 16,
                                                    'verticalPadding': 8,
                                                    'radius': 8,
                                                    'fontSize': 14,
                                                    'iconSize': 18,
                                                    'action': () =>
                                                        Get.toNamed('/editor'),
                                                  },
                                                ),
                                                DynamicWidgetData(
                                                  type: 'Row',
                                                  properties: {
                                                    'spacing': 12,
                                                    'crossAxisAlignment':
                                                        'center',
                                                  },
                                                  children: [
                                                    // NOTE: view button
                                                    DynamicWidgetData(
                                                      type: 'Button',
                                                      properties: {
                                                        'color':
                                                            Colors.transparent,
                                                        'hoverBorderWidth': 2,
                                                        'rippleColor':
                                                            Colors.black26,
                                                        'borderColor': AppTheme
                                                            .onSurface
                                                            .withOpacity(0.2),
                                                        'borderWidth': 1,
                                                        'isButton': true,
                                                        'svgIcon':
                                                            'assets/svg/eye-open.svg',
                                                        'svgIconColor':
                                                            AppTheme.onSurface,
                                                        'hoverColor': AppTheme
                                                            .onSurface
                                                            .withAlpha(30),
                                                        'padding': 8,
                                                        'radius': 8,
                                                        'fontSize': 14,
                                                        'iconSize': 18,
                                                        'action': () {},
                                                      },
                                                    ),
                                                    // NOTE: copy button
                                                    DynamicWidgetData(
                                                      type: 'Button',
                                                      properties: {
                                                        'color':
                                                            Colors.transparent,
                                                        'hoverBorderWidth': 2,
                                                        'rippleColor':
                                                            Colors.black26,
                                                        'borderColor': AppTheme
                                                            .onSurface
                                                            .withOpacity(0.2),
                                                        'borderWidth': 1,
                                                        'isButton': true,
                                                        'svgIcon':
                                                            'assets/svg/copy.svg',
                                                        'svgIconColor':
                                                            AppTheme.onSurface,
                                                        'hoverColor': AppTheme
                                                            .success
                                                            .withAlpha(40),
                                                        'padding': 8,
                                                        'radius': 8,
                                                        'fontSize': 14,
                                                        'iconSize': 18,
                                                        'action': () {},
                                                      },
                                                    ),
                                                    // NOTE: delete button
                                                    DynamicWidgetData(
                                                      type: 'Button',
                                                      properties: {
                                                        'color':
                                                            Colors.transparent,
                                                        'hoverBorderWidth': 2,
                                                        'rippleColor':
                                                            Colors.black26,
                                                        'borderColor': AppTheme
                                                            .onSurface
                                                            .withOpacity(0.2),
                                                        'borderWidth': 1,
                                                        'isButton': true,
                                                        'svgIcon':
                                                            'assets/svg/delete.svg',
                                                        'svgIconColor':
                                                            AppTheme.error,
                                                        'hoverColor': AppTheme
                                                            .error
                                                            .withAlpha(30),
                                                        'padding': 8,
                                                        'radius': 8,
                                                        'fontSize': 14,
                                                        'iconSize': 18,
                                                        'action': () {},
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
