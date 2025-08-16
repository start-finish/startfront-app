import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/drop_component.dart';
import '../../dynamic/data/data.dart';

class EditorController extends GetxController {
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

  // final droppedWidgets = <DynamicWidgetData>[].obs;

  // void addWidget(DynamicWidgetData widget) {
  //   droppedWidgets.add(widget);
  // }

  List<dynamic> widgets = [
    {
      'title': 'Button',
      'subTitle': 'Button',
      'type': 'Control',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'Text',
      'subTitle': 'Text Widget',
      'type': 'Dispaly',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'TextField',
      'subTitle': 'Text Field',
      'type': 'Input',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'Row',
      'subTitle': 'Row Layout',
      'type': 'Input',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
    {
      'title': 'Column',
      'subTitle': 'Column Layout',
      'type': 'Input',
      'propertiesCount': '5',
      'functionCount': '2',
      'updated_at': 'Jun 10, 2024',
    },
  ];

  // var widgets = <Map<String, String>>[
  //   {'title': 'Text'},
  //   {'title': 'TextField'},
  //   {'title': 'ElevatedButton'},
  //   // add more as needed
  // ];

  var droppedWidgets = <DynamicWidgetData>[].obs;

  /// Track the selected widget
  final selectedWidget = Rxn<DynamicWidgetData>();

  /// Add widget to the canvas
  void addWidget(DynamicWidgetData widgetData) {
    droppedWidgets.add(widgetData);
  }

  /// Select a widget
  void selectWidget(DynamicWidgetData widget) {
    selectedWidget.value = widget;
  }

  /// Duplicate a widget
  void duplicateWidget(DynamicWidgetData widget) {
    final index = droppedWidgets.indexOf(widget);
    if (index != -1) {
      final duplicated = DynamicWidgetData(
        type: widget.type,
        properties: Map<String, dynamic>.from(widget.properties),
        child: widget.child,
        children: List.from(widget.children),
      );
      droppedWidgets.insert(index + 1, duplicated);
    }
  }

  /// Delete a widget
  void deleteWidget(DynamicWidgetData widget) {
    droppedWidgets.remove(widget);
    if (selectedWidget.value == widget) {
      selectedWidget.value = null;
    }
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
                'title': 'Project: Project Name',
                'subTitle': 'StartFont Editor Studio',
                'action': [
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
                          'spacing': 6,
                          'crossAxisAlignment': 'center',
                        },
                        children: [
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'borderColor':
                                  AppTheme.secondary.withOpacity(0.5),
                              'hoverColor': AppTheme.secondary.withOpacity(0.2),
                              'title': 'Templates',
                              'svgIcon': 'assets/svg/widget-presets.svg',
                              'svgIconColor': AppTheme.secondary,
                              'textColor': AppTheme.secondary,
                              'horizontalPadding': 8,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'borderColor':
                                  AppTheme.secondary.withOpacity(0.5),
                              'hoverColor': AppTheme.secondary.withOpacity(0.2),
                              'title': 'Theme',
                              'svgIcon': 'assets/svg/theme.svg',
                              'svgIconColor': AppTheme.secondary,
                              'textColor': AppTheme.secondary,
                              'horizontalPadding': 8,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'borderColor':
                                  AppTheme.secondary.withOpacity(0.5),
                              'hoverColor': AppTheme.secondary.withOpacity(0.2),
                              'title': 'Assets',
                              'svgIcon': 'assets/svg/assets.svg',
                              'svgIconColor': AppTheme.secondary,
                              'textColor': AppTheme.secondary,
                              'horizontalPadding': 8,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'borderColor':
                                  AppTheme.secondary.withOpacity(0.5),
                              'hoverColor': AppTheme.secondary.withOpacity(0.2),
                              'title': 'APIs',
                              'svgIcon': 'assets/svg/folder.svg',
                              'svgIconColor': AppTheme.secondary,
                              'textColor': AppTheme.secondary,
                              'horizontalPadding': 8,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                        ],
                      ),
                      DynamicWidgetData(
                        type: 'Container',
                        properties: {
                          'margin': 16,
                          'color': AppTheme.secondary.withOpacity(0.4),
                          'width': 1.5,
                          'radius': 20,
                          'height': double.infinity,
                        },
                      ),
                      DynamicWidgetData(
                        type: 'Row',
                        properties: {
                          'spacing': 6,
                          'crossAxisAlignment': 'center',
                        },
                        children: [
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'title': 'Save',
                              'svgIconColor': AppTheme.onPrimary,
                              'color': AppTheme.secondary,
                              'textColor': AppTheme.onPrimary,
                              'horizontalPadding': 16,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'title': 'Export Flutter Code',
                              'svgIconColor': AppTheme.onPrimary,
                              'color': AppTheme.primary,
                              'textColor': AppTheme.onPrimary,
                              'horizontalPadding': 16,
                              'verticalPadding': 8,
                              'radius': 8,
                              'fontSize': 14,
                              'iconSize': 18,
                              'action': () {},
                            },
                          ),
                          DynamicWidgetData(
                            type: 'Button',
                            properties: {
                              'borderWidth': 1,
                              'hoverBorderWidth': 2,
                              'title': 'Preview App',
                              'svgIconColor': AppTheme.onPrimary,
                              'color': AppTheme.success,
                              'textColor': AppTheme.onPrimary,
                              'horizontalPadding': 16,
                              'verticalPadding': 8,
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
                ],
              },
            ),
          ),
          DynamicWidgetData(
            type: 'Expanded',
            properties: {},
            child: DynamicWidgetData(
              type: 'Container',
              properties: {'padding': 16},
              child: DynamicWidgetData(
                type: 'Row',
                properties: {
                  'spacing': 16,
                },
                children: [
                  // NOTE: wiget palette
                  widgetPalette(),
                  // NOTE: widget tree
                  widgetTree(),
                  // NOTE: design canvas
                  designCanvas(),
                  // NOTE: properties
                  properties(),
                ],
              ),
            ),
          ),
        ],
      ),
    ).toWidget();
  }
  // Widget buildBody() {
  //   final controller = Get.find<EditorController>();

  //   return Scaffold(
  //     backgroundColor: AppTheme.background,
  //     appBar: AppBar(
  //       backgroundColor: AppTheme.surface,
  //       title: const Text("StartFont Editor Studio"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // 🔵 Widget Palette
  //           Expanded(
  //             flex: 1,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Widget Palette',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 ...widgets.map((item) {
  //                   final data = DynamicWidgetData(
  //                     type: item['title'],
  //                     properties: {'text': item['title']},
  //                   );

  //                   return Draggable<DynamicWidgetData>(
  //                     data: data,
  //                     feedback: Material(
  //                       color: Colors.transparent,
  //                       child: Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: Colors.blueAccent,
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Text(
  //                           item['title'],
  //                           style: const TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                     ),
  //                     childWhenDragging: Opacity(
  //                       opacity: 0.3,
  //                       child: widgetItemTile(item),
  //                     ),
  //                     child: widgetItemTile(item),
  //                   );
  //                 }),
  //               ],
  //             ),
  //           ),

  //           const SizedBox(width: 16),

  //           // 🔴 Design Canvas
  //           Expanded(
  //             flex: 3,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Design Canvas',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Expanded(
  //                   child: Container(
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.blue,
  //                       border: Border.all(color: Colors.grey),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: DragTarget<DynamicWidgetData>(
  //                       onAccept: (widgetData) => addWidget(widgetData),
  //                       builder: (context, candidateData, rejectedData) {
  //                         return Obx(
  //                           () => ListView(
  //                             children: droppedWidgets.map((e) {
  //                               final isSelected = selectedWidget.value == e;

  //                               return GestureDetector(
  //                                 onTap: () => selectWidget(e),
  //                                 child: Container(
  //                                   margin:
  //                                       const EdgeInsets.symmetric(vertical: 4),
  //                                   padding: const EdgeInsets.all(12),
  //                                   decoration: BoxDecoration(
  //                                     border: Border.all(
  //                                       color: isSelected
  //                                           ? Colors.white
  //                                           : Colors.transparent,
  //                                       width: 2,
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(8),
  //                                   ),
  //                                   child: Stack(
  //                                     alignment:
  //                                         AlignmentDirectional.centerStart,
  //                                     children: [
  //                                       e.toWidget(),
  //                                       if (isSelected)
  //                                         Positioned(
  //                                           right: 0,
  //                                           child: Row(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.center,
  //                                             children: [
  //                                               IconButton(
  //                                                 icon: const Icon(
  //                                                   Icons.copy,
  //                                                   size: 16,
  //                                                 ),
  //                                                 onPressed: () => controller
  //                                                     .duplicateWidget(e),
  //                                               ),
  //                                               IconButton(
  //                                                 icon: const Icon(
  //                                                   Icons.delete,
  //                                                   size: 16,
  //                                                 ),
  //                                                 onPressed: () => controller
  //                                                     .deleteWidget(e),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  widgetPalette() {
    return DynamicWidgetData(
      type: 'Expanded',
      properties: {'flexible': 1},
      child: DynamicWidgetData(
        type: 'Container',
        properties: {
          'color': AppTheme.surface,
          'radius': 16,
          'padding': 16,
        },
        child: DynamicWidgetData(
          type: 'Column',
          properties: {
            'maxAxisSize': 'max',
            'spacing': 8,
          },
          children: [
            DynamicWidgetData(
              type: 'Text',
              properties: {
                'text': 'Widget Palette',
                'fontSize': 17,
                'fontWeight': 'bold',
                'color': AppTheme.secondary,
              },
            ),
            DynamicWidgetData(
              type: 'Text',
              properties: {
                'text': 'Drag widgets to canvas',
                'fontSize': 13,
                'color': AppTheme.onSurface,
              },
            ),
            DynamicWidgetData(
              type: 'Drag',
              properties: {
                'dragList': widgets.map((item) {
                  return DynamicWidgetData(
                    type: item['title'],
                    properties: {
                      'title': item['title'],
                      'subTitle': item['subTitle'],
                      'widgetType': item['type'],
                      'text': item['title'],
                    },
                  );
                }).toList(),
              },
            ),
            // DynamicWidgetData(
            //   type: 'Column',
            //   properties: {
            //     'spacing': 8,
            //   },
            //   children: widgets.map((item) {
            //     return DynamicWidgetData(
            //       type: 'Button',
            //       properties: {
            //         'color': AppTheme.background.withOpacity(0.5),
            //         'borderColor': AppTheme.secondary.withOpacity(0.3),
            //         'hoverBorderColor': AppTheme.primary,
            //         'borderWidth': 0.4,
            //         'hoverBorderWidth': 1.2,
            //         'radius': 12,
            //         'action': () => null
            //       },
            //       child: DynamicWidgetData(
            //         type: 'Column',
            //         properties: {
            //           'mainAxisAlignment': 'center',
            //         },
            //         children: [
            //           DynamicWidgetData(
            //             type: 'Container',
            //             properties: {
            //               'padding': 8,
            //               'width': double.infinity,
            //             },
            //             child: DynamicWidgetData(
            //               type: 'Row',
            //               properties: {
            //                 'spacing': 8,
            //                 'crossAxisAlignment': 'center',
            //               },
            //               children: [
            //                 DynamicWidgetData(
            //                   type: 'Container',
            //                   properties: {
            //                     'padding': 4,
            //                   },
            //                   child: DynamicWidgetData(
            //                     type: 'SvgImage',
            //                     properties: {
            //                       'width': 20,
            //                       'height': 20,
            //                       'image': 'assets/svg/widget-manage.svg',
            //                       'color': Colors.blueAccent.shade700,
            //                     },
            //                   ),
            //                 ),
            //                 DynamicWidgetData(
            //                   type: 'Column',
            //                   properties: {
            //                     'mainAxisSize': 'min',
            //                   },
            //                   children: [
            //                     DynamicWidgetData(
            //                       type: 'Text',
            //                       properties: {
            //                         'text': item['title'],
            //                         'fontSize': 14,
            //                         'fontWeight': 'bold',
            //                         'color': AppTheme.onSurface,
            //                       },
            //                     ),
            //                     DynamicWidgetData(
            //                       type: 'Text',
            //                       properties: {
            //                         'text': item['subTitle'],
            //                         'fontSize': 12,
            //                         'color':
            //                             AppTheme.secondary.withOpacity(0.7),
            //                       },
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ),

            DynamicWidgetData(
              type: 'Text',
              properties: {
                'text': 'Drag widgets to canvas',
                'fontSize': 13,
                'color': AppTheme.onSurface,
              },
            ),
          ],
        ),
      ),
    );
  }

  // widgetPalette() {
  //   // final controller = Get.find<EditorController>();

  //   return DynamicWidgetData(
  //     type: 'Expanded',
  //     properties: {'flexible': 1},
  //     child: DynamicWidgetData(
  //       type: 'Container',
  //       properties: {
  //         'color': AppTheme.surface,
  //         'radius': 16,
  //         'padding': 16,
  //       },
  //       child: DynamicWidgetData(
  //         type: 'Column',
  //         properties: {
  //           'maxAxisSize': 'max',
  //           'spacing': 8,
  //         },
  //         children: [
  //           DynamicWidgetData(
  //             type: 'Text',
  //             properties: {
  //               'text': 'Widget Palette',
  //               'fontSize': 17,
  //               'fontWeight': 'bold',
  //               'color': AppTheme.secondary,
  //             },
  //           ),
  //           DynamicWidgetData(
  //             type: 'Text',
  //             properties: {
  //               'text': 'Drag widgets to canvas',
  //               'fontSize': 13,
  //               'color': AppTheme.onSurface,
  //             },
  //           ),
  //           DynamicWidgetData(
  //             type: 'Custom',
  //             properties: {
  //               'builder': (context) => Column(
  //                     children: widgets.map((item) {
  //                       final data = DynamicWidgetData(
  //                         type: item['title'],
  //                         properties: {
  //                           'text': item['title'],
  //                         },
  //                       );

  //                       return Draggable<DynamicWidgetData>(
  //                         data: data,
  //                         feedback: Material(
  //                           color: Colors.transparent,
  //                           child: Container(
  //                             padding: EdgeInsets.all(8),
  //                             decoration: BoxDecoration(
  //                               color: Colors.blueAccent.shade700,
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             child: Text(
  //                               item['title'],
  //                               style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         childWhenDragging: Opacity(
  //                           opacity: 0.3,
  //                           child: widgetItemTile(item),
  //                         ),
  //                         child: widgetItemTile(item),
  //                       );
  //                     }).toList(),
  //                   ),
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // TODO: do drag drop widget

  Widget widgetItemTile(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.secondary.withOpacity(0.3),
          width: 0.4,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.widgets,
                color: Colors.blueAccent.shade700, size: 20),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurface),
              ),
              Text(
                item['subTitle'],
                style: TextStyle(
                    fontSize: 12, color: AppTheme.secondary.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  widgetTree() {
    return DynamicWidgetData(
      type: 'Expanded',
      properties: {'flexible': 1},
      child: DynamicWidgetData(
        type: 'Container',
        properties: {
          'color': AppTheme.background,
          'radius': 16,
        },
        child: DynamicWidgetData(
          type: 'Column',
          properties: {
            'maxAxisSize': 'max',
          },
          children: [
            DynamicWidgetData(
              type: 'Text',
              properties: {
                'text': 'Widget Tree',
              },
            ),
          ],
        ),
      ),
    );
  }

  designCanvas() {
    return DynamicWidgetData(
      type: 'Expanded',
      properties: {'flex': 3},
      child: DynamicWidgetData(
        type: 'Container',
        properties: {
          'color': AppTheme.background,
          'radius': 16,
        },
        child: DynamicWidgetData(
          type: 'Drop',
          properties: {
            'placeholder': 'Drop widgets here',
            'padding': 16.0,
            'radius': 12.0,
            'color': Colors.white,
            'borderColor': Colors.grey,
            'borderWidth': 1.0,
          },
        ),
        //   child: DynamicWidgetData(
        //     type: 'Obx',
        //     properties: {'builder': (){}},
        //   ),
        //   child: Obx(() => Column(
        //         children: [
        //           Text('Design Canvas'),
        //           Expanded(
        //             child: DragTarget<DynamicWidgetData>(
        //               onAccept: (widgetData) {
        //                 addWidget(widgetData); // or addWidget()
        //               },
        //               builder: (context, candidateData, rejectedData) {
        //                 return ListView(
        //                   padding: EdgeInsets.all(8),
        //                   children: droppedWidgets
        //                       .map((widget) =>
        //                           widget.toWidget()) // or custom builder
        //                       .toList(),
        //                 );
        //               },
        //             ),
        //           ),
        //         ],
        //       )),
      ),
    );
  }

  // designCanvas() {
  //   final controller = Get.find<EditorController>();

  //   return DynamicWidgetData(
  //     type: 'Expanded',
  //     properties: {'flex': 3},
  //     child: DynamicWidgetData(
  //       type: 'Container',
  //       properties: {
  //         'color': AppTheme.background,
  //         'radius': 16,
  //         'padding': 16,
  //       },
  //       child: DynamicWidgetData(
  //         type: 'Column',
  //         properties: {
  //           'mainAxisSize': 'max',
  //           'spacing': 12,
  //         },
  //         children: [
  //           DynamicWidgetData(
  //             type: 'Text',
  //             properties: {
  //               'text': 'Design Canvas',
  //               'fontSize': 18,
  //               'fontWeight': 'bold',
  //               'color': AppTheme.onSurface,
  //             },
  //           ),
  //           DynamicWidgetData(
  //             type: 'Expanded',
  //             properties: {},
  //             child: DynamicWidgetData(
  //               type: 'Container',
  //               properties: {
  //                 'color': Colors.white,
  //                 'radius': 12,
  //                 'padding': 16,
  //                 'borderColor': Colors.grey,
  //                 'borderWidth': 1.2,
  //               },
  //               child: DynamicWidgetData(
  //                 type: 'Obx',
  //                 properties: {
  //                   'builder': (context) => DragTarget<DynamicWidgetData>(
  //                         onAccept: (widget) => addWidget(widget),
  //                         builder: (context, candidateData, rejectedData) {
  //                           return Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: droppedWidgets
  //                                 .map((e) =>
  //                                     DynamicWidgetFactory.createWidget(e))
  //                                 .toList(),
  //                           );
  //                         },
  //                       ),
  //                 },
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  properties() {
    return DynamicWidgetData(
      type: 'Expanded',
      properties: {'flexible': 1},
      child: DynamicWidgetData(
        type: 'Container',
        properties: {
          'color': AppTheme.surface,
          'radius': 16,
        },
        child: DynamicWidgetData(
          type: 'Column',
          properties: {
            'maxAxisSize': 'max',
          },
          children: [
            DynamicWidgetData(
              type: 'Text',
              properties: {
                'text': 'Properties',
              },
            ),
          ],
        ),
      ),
    );
  }
}
