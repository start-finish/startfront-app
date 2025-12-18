import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../domain/service/dynamic_service.dart';
import '../../../../domain/service/handle_error.dart';
import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/data/data.dart';

class AdminWidgetManagementController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final DynamicService _dynamicService = DynamicService();

  // RxMap widgetPresets = {}.obs;
  // RxMap navigationItems = {}.obs;
  // RxMap navigationMenus = {}.obs;
  RxMap widgetList = {}.obs;

  Future<void> _makeMultipleRequests() async {
    try {
      // Show loading before starting the requests
      EasyLoading.show(status: 'Loading...');

      // Call multiple API requests concurrently
      final widgetListCall = _dynamicService
          .fetchDynamicData<Map<String, dynamic>>(
            isDynamicRSA: false,
            name: 'Widget List',
            reqBody: {
              "msgId": "WIDGETS_list",
              "data": {"page": 1, "limit": 10},
            },
          );

      // Wait for all requests to complete
      final results = await Future.wait([widgetListCall]);

      // Handle the responses
      bool errorOccurred = false; // Track if any error occurred

      for (var result in results) {
        result.fold((error) => errorOccurred = true, (data) {
          if (result == results[0]) {
            widgetList.value = data;
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

      EasyLoading.showSuccess('Fetch success', duration: Duration(seconds: 1));
    } catch (e) {
      // Handle unexpected errors
      HandleError.errors('ERROR_I_C', 'Unknown Error', e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteWidget(int id) async {
    try {
      // Show loading before starting the requests
      EasyLoading.show(status: 'Deleting...');

      // Call delete API
      final deleteCall = _dynamicService.fetchDynamicData<Map<String, dynamic>>(
        isDynamicRSA: false,
        name: 'Widget delete',
        reqBody: {
          "msgId": "WIDGETS_delete",
          "data": {"id": id},
        },
      );

      final results = await Future.wait([deleteCall]);

      bool errorOccurred = false;

      for (var result in results) {
        result.fold((error) => errorOccurred = true, (data) {
          if (result == results[0]) {
            EasyLoading.showSuccess(
              data['message'],
              duration: Duration(seconds: 2),
            );
          }
        });
      }

      if (errorOccurred) {
        HandleError.errors(
          'ERROR_I_C',
          'Request Failed',
          'Some requests failed.',
        );
      } else {
        // Fetch the latest widget list after deletion
        await _makeMultipleRequests(); // Refresh the data
      }
    } catch (e) {
      // Handle unexpected errors
      HandleError.errors('ERROR_I_C', 'Unknown Error', e.toString());
    } finally {
      EasyLoading.dismiss();
      update(); // Refresh the UI
    }
  }

  Future<void> createWidget() async {
    try {
      // Show loading before creating the widget
      EasyLoading.show(status: 'Creating...');

      // Call the create widget API
      final createCall = _dynamicService.fetchDynamicData<Map<String, dynamic>>(
        isDynamicRSA: false,
        name: 'Widget create',
        reqBody: {
          'msgId': 'WIDGETS_create',
          'data': {
            'widget_name': '',
            'widget_type': 'display',
            'widget_desc': '',
            'icon_value': 'Icons.bar_chart',
            'is_builtin': false, // built in = true no version
            'version': '1.0.0',
            'properties': {},
            'functions': {},
            'render_code': '',

            'created_by': 2,
          },
        },
      );

      final results = await Future.wait([createCall]);

      bool errorOccurred = false;

      for (var result in results) {
        result.fold((error) => errorOccurred = true, (data) {
          if (result == results[0]) {
            EasyLoading.showSuccess(
              data['message'],
              duration: Duration(seconds: 2),
            );
          }
        });
      }

      if (errorOccurred) {
        HandleError.errors(
          'ERROR_I_C',
          'Request Failed',
          'Some requests failed.',
        );
      } else {
        // Fetch the latest widget list after creation
        await _makeMultipleRequests(); // Refresh the data
      }
    } catch (e) {
      // Handle unexpected errors
      HandleError.errors('ERROR_I_C', 'Unknown Error', e.toString());
    } finally {
      EasyLoading.dismiss();
      update(); // Refresh the UI
    }
  }

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: this);
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

  // NOTE: basic info
  final widgetNameTF = TextEditingController();
  final widgetNameFN = FocusNode();
  RxList basicInfoTypeList = [
    'Control',
    'Display',
    'Input',
    'Layout',
    'Media',
  ].obs;
  final descTF = TextEditingController();
  final descFN = FocusNode();

  // NOTE: properties
  final propNameTF = TextEditingController();
  final propNameFN = FocusNode();
  RxList propTypeList = [
    'string',
    'number',
    'color',
    'boolean',
    'select',
    'action',
  ].obs;
  final propDefaultTF = TextEditingController();
  final propDefaultFN = FocusNode();
  final isPropRequired = false.obs;
  final RxList<Map<String, dynamic>> properties = <Map<String, dynamic>>[].obs;

  // NOTE: functions
  final functionNameTF = TextEditingController();
  final functionNameFN = FocusNode();
  final functionCodeTF = TextEditingController();
  final functionCodeFN = FocusNode();
  final RxList<Map<String, dynamic>> functions = <Map<String, dynamic>>[].obs;

  // NOTE: render code
  final renderCodeTF = TextEditingController();
  final renderCodeFN = FocusNode();

  List<dynamic> editWidgets(int widgetId) {
    return [
      {
        'icon': IconsaxPlusBroken.message_programming,
        'hoverIcon': IconsaxPlusBold.message_programming,
        'function': () {
          // placeholder function for other actions
        },
      },
      {
        'icon': IconsaxPlusBroken.setting_2,
        'hoverIcon': IconsaxPlusBold.setting_2,
        'function': () {
          // placeholder function for other actions
        },
      },
      {
        'icon': IconsaxPlusBroken.copy,
        'hoverIcon': IconsaxPlusBold.copy,
        'function': () {
          // placeholder function for other actions
        },
      },
      {
        'icon': IconsaxPlusBroken.edit,
        'hoverIcon': IconsaxPlusBold.edit,
        'function': () {
          // placeholder function for other actions
        },
      },
      {
        'icon': IconsaxPlusBroken.trash,
        'hoverIcon': IconsaxPlusBold.trash,
        'function': () {
          // Call deleteWidget with the dynamic widget id
          deleteWidget(widgetId);
        },
      },
    ];
  }

  buildBody() {
    return DynamicWidgetData(
      type: 'Container',
      properties: {'gradient': 'primary'},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'mainAxisSize': 'max', 'crossAxisAlignment': 'center'},
        children: [
          // NOTE: App Bar
          appBar(),

          // NOTE: Body
          body(),
        ],
      ),
    ).toWidget();
  }

  appBar() {
    return DynamicWidgetData(
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
                'borderWidth': 1,
                'hoverBorderWidth': 2,
                'title': 'Create Widget',
                'icon': IconsaxPlusBroken.add,
                'hoverIcon': IconsaxPlusLinear.add,
                'iconColor': AppTheme.onPrimary,
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
                      'title': 'Create New Widget',
                      'content': DynamicWidgetData(
                        type: 'Container',
                        properties: {'width': 800},
                        child: DynamicWidgetData(
                          type: 'Column',
                          properties: {'mainAxisSize': 'min'},
                          children: [
                            DynamicWidgetData(
                              type: 'TabBar',
                              properties: {
                                'tabs': [
                                  'Basic Info',
                                  'Properties',
                                  'Functions',
                                  'Render Code',
                                ],
                                'controller': tabController,
                                'indicatorStyle': 'box',
                                'indicatorColor': AppTheme.primary,
                                'backgroundColor': AppTheme.primary.withOpacity(
                                  0.05,
                                ),
                                'labelColor': AppTheme.onPrimary,
                                'unselectedLabelColor': AppTheme.primary,
                                'indicatorRadius': 12,
                                'radius': 30,
                                'height': 42,
                                'initialIndex': 0,
                                'isScrollable': false,
                                'isExpanded': false,
                                'tabViewHeight': Get.height * 0.5,
                              },
                              children: [
                                basicInfoTab(),
                                propTab(),
                                functionTab(),
                                renderCodeTab(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      'confirmText': 'Create Widget',
                      'onCancel': () {
                        widgetNameTF.text = '';
                        descTF.text = '';
                        properties.clear();
                        functions.clear();
                        renderCodeTF.text = '';
                      },
                      'onConfirm': () {
                        final email = Get.find<TextEditingController>(
                          tag: 'emailField',
                        ).text;
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
    );
  }

  body() {
    if (widgetList.isEmpty || widgetList['data'] == null) {
      return DynamicWidgetData(
        type: 'Center',
        child: DynamicWidgetData(
          type: 'Text',
          properties: {'text': 'Loading...'},
        ),
      ).toWidget();
    }

    final countData = widgetList['data']?['counts'];
    final widgetData = widgetList['data']?['widgets'];

    final countItems = [
      {'label': 'Total Widgets', 'value': countData['total']},
      {'label': 'Control Widgets', 'value': countData['control']},
      {'label': 'Input Widgets', 'value': countData['input']},
      {'label': 'Layout Widgets', 'value': countData['layout']},
    ];

    if (countData == null || widgetData == null) {
      return DynamicWidgetData(
        type: 'Center',
        child: DynamicWidgetData(
          type: 'Text',
          properties: {'text': 'Loading...'},
        ),
      ).toWidget();
    }

    return DynamicWidgetData(
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
                  'spacing': 32,
                },
                children: [
                  // NOTE: count
                  countData == null
                      ? DynamicWidgetData(type: 'Container')
                      : DynamicWidgetData(
                          type: 'FlexibleWrap',
                          properties: {'spacing': 12, 'runSpacing': 12},
                          children: countItems.map((item) {
                            return countItems == null
                                ? DynamicWidgetData(type: 'Container')
                                : DynamicWidgetData(
                                    type: 'Container',
                                    properties: {
                                      'maxWidth': getItemWidth(1280),
                                      'color': AppTheme.onSecondary,
                                      'padding': 24,
                                      'radius': 16,
                                      'borderWidth': 1,
                                      'borderColor': AppTheme.onSurface
                                          .withOpacity(0.15),
                                    },
                                    child: DynamicWidgetData(
                                      type: 'Column',
                                      properties: {'mainAxisSize': 'min'},
                                      children: [
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': item['value'].toString(),
                                            'fontSize': 22,
                                            'fontWeight': 'bold',
                                            'color': AppTheme.onSurface,
                                          },
                                        ),
                                        DynamicWidgetData(
                                          type: 'Text',
                                          properties: {
                                            'text': item['label'],
                                            'color': AppTheme.secondary,
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                          }).toList(),
                        ),

                  // NOTE: all widgets
                  widgetData == null
                      ? DynamicWidgetData(type: 'Container')
                      : DynamicWidgetData(
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
                                properties: {'padding': 24},
                                child: DynamicWidgetData(
                                  type: 'Text',
                                  properties: {
                                    'text':
                                        'All Widgets (${widgetData.length})',
                                    'fontSize': 17,
                                    'fontWeight': 'bold',
                                    'color': AppTheme.onSurface,
                                  },
                                ),
                              ),
                              DynamicWidgetData(
                                type: 'FlexibleWrap',
                                properties: {},
                                children: [
                                  ...widgetData.asMap().entries.map((data) {
                                    final index = data.key;
                                    final item = data.value;

                                    final total = widgetData
                                        .length; // 👈 this gives length

                                    return DynamicWidgetData(
                                      type: 'Button',
                                      properties: {
                                        'hoverColor': AppTheme.isDark
                                            ? Colors.white24
                                            : Colors.black.withOpacity(0.03),
                                        'hoverBorderWidth': 0,
                                        'radiusBottomLeft':
                                            data.value.length > index ? 16 : 0,
                                        'radiusBottomRight':
                                            data.value.length > index ? 16 : 0,
                                        'action': () => null,
                                      },
                                      child: DynamicWidgetData(
                                        type: 'Column',
                                        properties: {},
                                        children: [
                                          DynamicWidgetData(
                                            type: 'Container',
                                            properties: {
                                              'height': 0.5,
                                              'width': double.infinity,
                                              'color': AppTheme.onSurface
                                                  .withAlpha(80),
                                            },
                                          ),
                                          DynamicWidgetData(
                                            type: 'Container',
                                            properties: {
                                              'maxWidth': 1280,
                                              'padding': 24,
                                              'radius': 16,
                                            },
                                            child: DynamicWidgetData(
                                              type: 'Row',
                                              properties: {
                                                'mainAxisAlignment':
                                                    'spaceBetween',
                                              },
                                              children: [
                                                DynamicWidgetData(
                                                  type: 'Row',
                                                  properties: {'spacing': 16},
                                                  children: [
                                                    DynamicWidgetData(
                                                      type: 'Container',
                                                      properties: {
                                                        'color': Colors
                                                            .blueAccent
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
                                                              .blueAccent
                                                              .shade700,
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
                                                            'text':
                                                                '${item['label']}',
                                                            'fontSize': 16,
                                                            'fontWeight':
                                                                'bold',
                                                            'color': AppTheme
                                                                .onSurface,
                                                          },
                                                        ),
                                                        DynamicWidgetData(
                                                          type: 'Text',
                                                          properties: {
                                                            'text': item['key'],
                                                            'color': AppTheme
                                                                .secondary,
                                                          },
                                                        ),
                                                        DynamicWidgetData(
                                                          type: 'SizedBox',
                                                          properties: {
                                                            'height': 6,
                                                          },
                                                        ),
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
                                                                      0.11,
                                                                    ),
                                                              },
                                                              child: DynamicWidgetData(
                                                                type: 'Text',
                                                                properties: {
                                                                  'text':
                                                                      '${item['category']}',
                                                                  'fontSize':
                                                                      12,
                                                                  'color': AppTheme
                                                                      .secondary,
                                                                },
                                                              ),
                                                            ),
                                                            DynamicWidgetData(
                                                              type: 'Text',
                                                              properties: {
                                                                'text':
                                                                    ' properties',
                                                                'fontSize': 12,
                                                                'color': AppTheme
                                                                    .secondary,
                                                              },
                                                            ),
                                                            DynamicWidgetData(
                                                              type: 'Text',
                                                              properties: {
                                                                'text':
                                                                    ' functions',
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
                                                  properties: {'spacing': 12},
                                                  children: editWidgets(item['id'] ?? 0)
                                                      .asMap()
                                                      .map((index, btnItem) {
                                                        return MapEntry(
                                                          index,
                                                          DynamicWidgetData(
                                                            type: 'Button',
                                                            properties: {
                                                              'isButton': true,
                                                              'icon':
                                                                  btnItem['icon'],
                                                              'hoverIcon':
                                                                  btnItem['hoverIcon'],
                                                              'iconColor':
                                                                  AppTheme
                                                                      .primary,
                                                              'hoverColor':
                                                                  AppTheme
                                                                      .primary
                                                                      .withOpacity(
                                                                        0.1,
                                                                      ),
                                                              'padding': 8,
                                                              'radius': 8,
                                                              'fontSize': 14,
                                                              'iconSize': 18,
                                                              'action': () {
                                                                final fn =
                                                                    btnItem['function']; // Use btnItem['function'] directly
                                                                if (fn
                                                                    is Function) {
                                                                  fn(); // Execute the function
                                                                }
                                                              },
                                                            },
                                                          ),
                                                        );
                                                      })
                                                      .values
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
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
    );
  }

  basicInfoTab() {
    return DynamicWidgetData(
      type: 'Scroll',
      properties: {},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'spacing': 12},
        children: [
          DynamicWidgetData(
            type: 'IconSelectionButton',
            properties: {
              // 'targetData': targetButtonData,
              'propertyKey': 'hoverIconKey', // The hover property key
              'label': 'Hover Icon',
            },
          ),
          DynamicWidgetData(
            type: 'TextField',
            properties: {
              'label': 'Widget Name',
              'labelColor': AppTheme.onBackground,
              'borderColor': AppTheme.onBackground,
              'controller': widgetNameTF,
              'focusNode': widgetNameFN,
              'nextFocus': descFN,
              'hintText': 'Widget name',
              'isRequired': true,
              'errorText': '',
              'showError': false.obs,
              'borderRadius': 8,
            },
          ),
          DynamicWidgetData(
            type: 'Dropdown',
            properties: {
              'label': 'Type',
              'isRequired': true,
              'errorText': '',
              'showError': false.obs,
              'width': Get.width,
              'items': basicInfoTypeList,
              'hintText': 'Type',
              'controllerKey': 'basic_info_type',
              'initialValue': 'All Status',
              'onChanged': (value) {
                print('Selected: $value');
              },
              'labelColor': AppTheme.onBackground,
              'borderColor': AppTheme.onBackground,
              'backgroundColor': AppTheme.onPrimary,
              'borderWidth': 1.0,
              'radius': 8,
              'enableSearch': false,
            },
          ),
          DynamicWidgetData(
            type: 'TextField',
            properties: {
              'label': 'Description',
              'labelColor': AppTheme.onBackground,
              'borderColor': AppTheme.onBackground,
              'controller': descTF,
              'focusNode': descFN,
              // 'nextFocus': passwordFN,
              'hintText': 'Widget description',
              'isRequired': true,
              'errorText': '',
              'showError': false.obs,
              'borderRadius': 8,
              'minLines': 3,
              'maxLines': 6,
            },
          ),
        ],
      ),
    );
  }

  propTab() {
    return DynamicWidgetData(
      type: 'Scroll',
      properties: {},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'spacing': 12},
        children: [
          addGroup(
            title: 'Propety',
            buttonAction: _addProperty,
            items: [
              DynamicWidgetData(
                type: 'Row',
                properties: {'spacing': 12},
                children: [
                  DynamicWidgetData(
                    type: 'Flexible',
                    properties: {},
                    child: DynamicWidgetData(
                      type: 'TextField',
                      properties: {
                        'label': 'Property Name',
                        'labelColor': AppTheme.onBackground,
                        'borderColor': AppTheme.onBackground,
                        'controller': propNameTF,
                        'focusNode': propNameFN,
                        'nextFocus': propDefaultFN,
                        'hintText': 'Property name',
                        'isRequired': true,
                        'errorText': '',
                        'showError': false.obs,
                        'borderRadius': 8,
                      },
                    ),
                  ),
                  DynamicWidgetData(
                    type: 'Flexible',
                    properties: {},
                    child: DynamicWidgetData(
                      type: 'Dropdown',
                      properties: {
                        'label': 'Type',
                        'isRequired': true,
                        'errorText': '',
                        'showError': false.obs,
                        'width': Get.width,
                        'items': propTypeList,
                        'hintText': 'Type',
                        'controllerKey': 'prop_type',
                        'initialValue': 'string',
                        'onChanged': (value) {
                          print('Selected: $value');
                        },
                        'labelColor': AppTheme.onBackground,
                        'borderColor': AppTheme.onBackground,
                        'backgroundColor': AppTheme.onPrimary,
                        'borderWidth': 1.0,
                        'radius': 8,
                        'enableSearch': false,
                      },
                    ),
                  ),
                ],
              ),
              DynamicWidgetData(
                type: 'Row',
                properties: {'spacing': 12},
                children: [
                  DynamicWidgetData(
                    type: 'Flexible',
                    properties: {},
                    child: DynamicWidgetData(
                      type: 'TextField',
                      properties: {
                        'label': 'Default Value',
                        'labelColor': AppTheme.onBackground,
                        'borderColor': AppTheme.onBackground,
                        'controller': propDefaultTF,
                        'focusNode': propDefaultFN,
                        'hintText': 'Default value',
                        'isRequired': true,
                        'errorText': '',
                        'showError': false.obs,
                        'borderRadius': 8,
                      },
                    ),
                  ),
                  DynamicWidgetData(
                    type: 'Flexible',
                    properties: {},
                    child: DynamicWidgetData(
                      type: 'Checkbox',
                      properties: {
                        'label': '',
                        'title': 'Required',
                        'key': 'prop_required',
                        'initialValue': isPropRequired,
                        'onChanged': (value) {
                          print('Checkbox value: $value');
                        },
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          DynamicWidgetData(
            type: 'Obx',
            properties: {
              'builder': () {
                return DynamicWidgetData(
                  type: 'Column',
                  properties: {'spacing': 12},
                  children: [
                    DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text': 'Current Properties',
                        'fontSize': 16,
                        'fontWeight': 'bold',
                      },
                    ),
                    for (var property in properties)
                      DynamicWidgetData(
                        type: 'Container',
                        properties: {
                          'width': Get.width,
                          'color': AppTheme.primary.withOpacity(0.06),
                          'verticalPadding': 8,
                          'horizontalPadding': 12,
                          'radius': 8,
                        },
                        child: DynamicWidgetData(
                          type: 'Row',
                          properties: {
                            'mainAxisAlignment': 'spaceBetween',
                            'crossAxisAlignment': 'center',
                          },
                          children: [
                            DynamicWidgetData(
                              type: 'Row',
                              properties: {'spacing': 8},
                              children: [
                                DynamicWidgetData(
                                  type: 'Text',
                                  properties: {
                                    'text':
                                        '${property['propertyName']} (${property['type']})',
                                  },
                                ),
                                if (property['requiredValue'])
                                  DynamicWidgetData(
                                    type: 'Text',
                                    properties: {
                                      'text': '*',
                                      'color': AppTheme.error,
                                    },
                                  ),
                              ],
                            ),
                            DynamicWidgetData(
                              type: 'Button',
                              properties: {
                                'isButton': true,
                                'icon': IconsaxPlusBroken.trash,
                                'hoverIcon': IconsaxPlusBold.trash,
                                'iconColor': AppTheme.error,
                                'hoverColor': AppTheme.error.withOpacity(0.1),
                                'padding': 8,
                                'radius': 8,
                                'fontSize': 14,
                                'iconSize': 18,
                                'action': () => _removeProperty(property),
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            },
          ),
        ],
      ),
    );
  }

  functionTab() {
    return DynamicWidgetData(
      type: 'Scroll',
      properties: {},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'spacing': 12},
        children: [
          addGroup(
            title: 'Custom Function',
            buttonTitle: 'Function',
            buttonAction: _addFunction,
            items: [
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Function Name',
                  'labelColor': AppTheme.onBackground,
                  'borderColor': AppTheme.onBackground,
                  'controller': functionNameTF,
                  'focusNode': functionNameFN,
                  'nextFocus': functionCodeFN,
                  'hintText': 'Function name',
                  'isRequired': false,
                  'errorText': '',
                  'showError': false.obs,
                  'borderRadius': 8,
                },
              ),
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Function Code',
                  'labelColor': AppTheme.onBackground,
                  'borderColor': AppTheme.onBackground,
                  'controller': functionCodeTF,
                  'focusNode': functionCodeFN,
                  'hintText': 'Function code',
                  'isRequired': false,
                  'errorText': '',
                  'showError': false.obs,
                  'borderRadius': 8,
                  'minLines': 5,
                  'maxLines': 10,
                },
              ),
            ],
          ),
          DynamicWidgetData(
            type: 'Obx',
            properties: {
              'builder': () {
                return DynamicWidgetData(
                  type: 'Column',
                  properties: {'spacing': 12},
                  children: [
                    DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text': 'Custom Functions',
                        'fontSize': 16,
                        'fontWeight': 'bold',
                      },
                    ),
                    for (var function in functions)
                      DynamicWidgetData(
                        type: 'Container',
                        properties: {
                          'width': Get.width,
                          'color': AppTheme.primary.withOpacity(0.06),
                          'verticalPadding': 8,
                          'horizontalPadding': 12,
                          'radius': 8,
                        },
                        child: DynamicWidgetData(
                          type: 'Row',
                          properties: {
                            'mainAxisAlignment': 'spaceBetween',
                            'crossAxisAlignment': 'center',
                          },
                          children: [
                            DynamicWidgetData(
                              type: 'Row',
                              properties: {'spacing': 8},
                              children: [
                                DynamicWidgetData(
                                  type: 'Text',
                                  properties: {
                                    'text': '${function['funcationName']}',
                                  },
                                ),
                              ],
                            ),
                            DynamicWidgetData(
                              type: 'Button',
                              properties: {
                                'isButton': true,
                                'icon': IconsaxPlusBroken.trash,
                                'hoverIcon': IconsaxPlusBold.trash,
                                'iconColor': AppTheme.error,
                                'hoverColor': AppTheme.error.withOpacity(0.1),
                                'padding': 8,
                                'radius': 8,
                                'fontSize': 14,
                                'iconSize': 18,
                                'action': () => _removeFunction(function),
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            },
          ),
        ],
      ),
    );
  }

  renderCodeTab() {
    return DynamicWidgetData(
      type: 'Scroll',
      properties: {},
      child: DynamicWidgetData(
        type: 'Column',
        properties: {},
        children: [
          DynamicWidgetData(
            type: 'TextField',
            properties: {
              'label': 'Render Code (Dart)',
              'labelColor': AppTheme.onBackground,
              'borderColor': AppTheme.onBackground,
              'controller': renderCodeTF,
              'focusNode': renderCodeFN,
              'hintText': 'Dart code for render the widget',
              'isRequired': false,
              'errorText': '',
              'showError': false.obs,
              'minLines': 15,
              'maxLines': 20,
            },
          ),
        ],
      ),
    );
  }

  addGroup({title, items, buttonTitle, buttonAction}) {
    return DynamicWidgetData(
      type: 'Container',
      properties: {
        'width': Get.width,
        'padding': 12,
        'radius': 12,
        'borderColor': AppTheme.onBackground,
        'borderWidth': 0.5,
      },
      child: DynamicWidgetData(
        type: 'Column',
        properties: {'spacing': 12},
        children: [
          DynamicWidgetData(
            type: 'Text',
            properties: {
              'text': 'Add $title',
              'fontSize': 16,
              'fontWeight': 'bold',
            },
          ),
          DynamicWidgetData(
            type: 'Column',
            properties: {'spacing': 12},
            children: items,
          ),

          // button
          DynamicWidgetData(
            type: 'Button',
            properties: {
              'borderWidth': 1,
              'hoverBorderWidth': 1,
              'title': 'Add ${buttonTitle ?? title}',
              'color': AppTheme.onBackground,
              'textColor': AppTheme.onPrimary,
              'horizontalPadding': 16,
              'verticalPadding': 8,
              'radius': 8,
              'fontSize': 13,
              'action': buttonAction,
            },
          ),
        ],
      ),
    );
  }

  void _addProperty() {
    final propertyName = propNameTF.text;
    final defaultValue = propDefaultTF.text;
    final requiredValue = isPropRequired.value;

    if (propertyName.isNotEmpty) {
      properties.add({
        'propertyName': propertyName,
        'type': 'string',
        'defaultValue': defaultValue,
        'requiredValue': requiredValue,
      });

      // Clear the input fields
      propNameTF.clear();
      propDefaultTF.clear();
    }
  }

  // Remove Property from the list
  void _removeProperty(Map<String, dynamic> property) {
    properties.remove(property);
  }

  void _addFunction() {
    final functionName = functionNameTF.text;
    final functionCode = functionCodeTF.text;

    if (functionName.isNotEmpty) {
      functions.add({
        'funcationName': functionName,
        'functionCode': functionCode,
      });

      // Clear the input fields
      functionNameTF.clear();
      functionCodeTF.clear();
    }
  }

  // Remove Property from the list
  void _removeFunction(Map<String, dynamic> funtion) {
    functions.remove(funtion);
  }
}
