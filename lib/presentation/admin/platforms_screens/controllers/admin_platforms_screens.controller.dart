import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/data/data.dart';

class AdminPlatformsScreensController extends GetxController {
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
                        'spacing': 32,
                      },
                      children: [
                        // DynamicWidgetData(
                        //   type: 'FlexibleWrap',
                        //   properties: {
                        //     'spacing': 12,
                        //     'runSpacing': 12,
                        //   },
                        //   children: texts.map((text) {
                        //     return DynamicWidgetData(
                        //       type: 'Container',
                        //       properties: {
                        //         'maxWidth': getItemWidth(1280),
                        //         'color': AppTheme.onSecondary,
                        //         'padding': 24,
                        //         'radius': 16,
                        //         'borderWidth': 1,
                        //         'borderColor':
                        //             AppTheme.onSurface.withOpacity(0.15),
                        //       },
                        //       child: DynamicWidgetData(
                        //         type: 'Column',
                        //         properties: {
                        //           'mainAxisSize': 'min',
                        //         },
                        //         children: [
                        //           DynamicWidgetData(
                        //             type: 'Text',
                        //             properties: {
                        //               'text': '22',
                        //               'fontSize': 22,
                        //               'fontWeight': 'bold',
                        //               'color': AppTheme.onSurface,
                        //             },
                        //           ),
                        //           DynamicWidgetData(
                        //             type: 'Text',
                        //             properties: {
                        //               'text': text,
                        //               'color': AppTheme.secondary,
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
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
                              // DynamicWidgetData(
                              //   type: 'FlexibleWrap',
                              //   properties: {},
                              //   children: widgets.map((item) {
                              //     return DynamicWidgetData(
                              //       type: 'Column',
                              //       properties: {},
                              //       children: [
                              //         DynamicWidgetData(
                              //           type: 'Container',
                              //           properties: {
                              //             'height': 0.5,
                              //             'width': double.infinity,
                              //             'color':
                              //                 AppTheme.onSurface.withAlpha(80),
                              //           },
                              //         ),
                              //         DynamicWidgetData(
                              //           type: 'Container',
                              //           properties: {
                              //             'maxWidth': 1280,
                              //             'color': AppTheme.onSecondary,
                              //             'padding': 24,
                              //             'radius': 16,
                              //           },
                              //           child: DynamicWidgetData(
                              //             type: 'Row',
                              //             properties: {
                              //               'mainAxisAlignment': 'spaceBetween',
                              //             },
                              //             children: [
                              //               // DynamicWidgetData(
                              //               //   type: 'Row',
                              //               //   properties: {
                              //               //     'spacing': 16,
                              //               //   },
                              //               //   children: [
                              //               //     DynamicWidgetData(
                              //               //       type: 'Container',
                              //               //       properties: {
                              //               //         'color': Colors.blueAccent
                              //               //             .withOpacity(0.2),
                              //               //         'padding': 8,
                              //               //         'radius': 8,
                              //               //       },
                              //               //       child: DynamicWidgetData(
                              //               //         type: 'SvgImage',
                              //               //         properties: {
                              //               //           'width': 24,
                              //               //           'height': 24,
                              //               //           'image':
                              //               //               'assets/svg/widget-manage.svg',
                              //               //           'color': Colors
                              //               //               .blueAccent.shade700,
                              //               //         },
                              //               //       ),
                              //               //     ),
                              //               //     DynamicWidgetData(
                              //               //       type: 'Column',
                              //               //       properties: {
                              //               //         'mainAxisSize': 'min',
                              //               //       },
                              //               //       children: [
                              //               //         DynamicWidgetData(
                              //               //           type: 'Text',
                              //               //           properties: {
                              //               //             'text': item['title'],
                              //               //             'fontSize': 16,
                              //               //             'fontWeight': 'bold',
                              //               //             'color':
                              //               //                 AppTheme.onSurface,
                              //               //           },
                              //               //         ),
                              //               //         DynamicWidgetData(
                              //               //           type: 'Text',
                              //               //           properties: {
                              //               //             'text':
                              //               //                 item['subTitle'],
                              //               //             'color':
                              //               //                 AppTheme.secondary,
                              //               //           },
                              //               //         ),
                              //               //         DynamicWidgetData(
                              //               //             type: 'SizedBox',
                              //               //             properties: {
                              //               //               'height': 6
                              //               //             }),
                              //               //         DynamicWidgetData(
                              //               //           type: 'Row',
                              //               //           properties: {
                              //               //             'crossAxisAlignment':
                              //               //                 'center',
                              //               //             'spacing': 8,
                              //               //           },
                              //               //           children: [
                              //               //             DynamicWidgetData(
                              //               //               type: 'Container',
                              //               //               properties: {
                              //               //                 'verticalPadding':
                              //               //                     4,
                              //               //                 'horizontalPadding':
                              //               //                     8,
                              //               //                 'radius': 6,
                              //               //                 'color': AppTheme
                              //               //                     .primary
                              //               //                     .withOpacity(
                              //               //                         0.11),
                              //               //               },
                              //               //               child:
                              //               //                   DynamicWidgetData(
                              //               //                 type: 'Text',
                              //               //                 properties: {
                              //               //                   'text':
                              //               //                       item['type'],
                              //               //                   'fontSize': 12,
                              //               //                   'color': AppTheme
                              //               //                       .secondary,
                              //               //                 },
                              //               //               ),
                              //               //             ),
                              //               //             DynamicWidgetData(
                              //               //               type: 'Text',
                              //               //               properties: {
                              //               //                 'text':
                              //               //                     '${item['propertiesCount']} properties',
                              //               //                 'fontSize': 12,
                              //               //                 'color': AppTheme
                              //               //                     .secondary,
                              //               //               },
                              //               //             ),
                              //               //             DynamicWidgetData(
                              //               //               type: 'Text',
                              //               //               properties: {
                              //               //                 'text':
                              //               //                     '${item['functionCount']} functions',
                              //               //                 'fontSize': 12,
                              //               //                 'color': AppTheme
                              //               //                     .secondary,
                              //               //               },
                              //               //             ),
                              //               //             DynamicWidgetData(
                              //               //               type: 'Text',
                              //               //               properties: {
                              //               //                 'text':
                              //               //                     'Updated ${item['updated_at']}',
                              //               //                 'fontSize': 12,
                              //               //                 'color': AppTheme
                              //               //                     .secondary,
                              //               //               },
                              //               //             ),
                              //               //           ],
                              //               //         ),
                              //               //       ],
                              //               //     ),
                              //               //   ],
                              //               // ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   }).toList(),
                              // ),
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
