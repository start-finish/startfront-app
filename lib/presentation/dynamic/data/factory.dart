import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../editor/controllers/editor.controller.dart';
import '../component/appBar_component.dart';
import '../component/button_component.dart';
import '../component/center_component.dart';
import '../component/checkbox_component.dart';
import '../component/column_component.dart';
import '../component/column_list_component.dart';
import '../component/container_component.dart';
import '../component/drag_component.dart';
import '../component/drop_component.dart';
import '../component/dropdown_component.dart';
import '../component/expand_component.dart';
import '../component/flexible_component.dart';
import '../component/icon_component.dart';
import '../component/icon_selection_button.dart';
import '../component/image_component.dart';
import '../component/list_view_component.dart';
import '../component/obx_component.dart';
import '../component/padding_component.dart';
import '../component/rotate_component.dart';
import '../component/row_component.dart';
import '../component/row_list_component.dart';
import '../component/scroll_component.dart';
import '../component/show_alert_component.dart';
import '../component/sizedbox_component.dart';
import '../component/snackbar_component.dart';
import '../component/stack_component.dart';
import '../component/svg_image_component.dart';
import '../component/tabbar_component.dart';
import '../component/text_component.dart';
import '../component/textfield_component.dart';
import '../component/flexible_wrap_component.dart';
import '../component/wrap_component.dart';
import 'data.dart';

class DynamicWidgetFactory {
  static Widget createWidget(DynamicWidgetData widgetData) {
    switch (widgetData.type) {
      case 'AppBar':
        return appBarComponent(data: widgetData);

      // child widget
      case 'Text':
        return textComponent(data: widgetData);
      case 'TextField':
        return textFieldComponent(data: widgetData);
      case 'Container':
        return containerComponent(data: widgetData);
      case 'Center':
        return centerComponent(data: widgetData);
      case 'Padding':
        return paddingComponent(data: widgetData);
      case 'SizedBox':
        return sizedBoxComponent(data: widgetData);
      case 'Scroll':
        return scrollComponent(data: widgetData);
      case 'Expanded':
        return expandedComponent(data: widgetData);
      case 'Flexible':
        return flexibleComponent(data: widgetData);
      case 'Button':
        final button = HoverRippleButton(data: widgetData);
        if (widgetData.properties['isExpanded'] == true) {
          return Expanded(child: button);
        } else {
          return button;
        }
      case 'Icon':
        return iconComponent(data: widgetData);
      case 'IconSelectionButton':
        final targetData = widgetData.properties['targetData'];
        final propertyKey = widgetData.properties['propertyKey'];
        final label = widgetData.properties['label'];

        if (targetData is DynamicWidgetData &&
            propertyKey is String &&
            label is String) {
          return IconSelectionButton(
            targetData: targetData,
            propertyKey: propertyKey,
            label: label,
          );
        }
        return const SizedBox.shrink();
      case 'Image':
        return imageComponent(data: widgetData);
      case 'SvgImage':
        return svgImageComponent(data: widgetData);
      case 'Rotate':
        return rotateComponent(data: widgetData);
      case 'SnackBar':
        showSnackbarComponent(data: widgetData);
        return const SizedBox.shrink();
      case 'Alert':
        showAlertComponent(data: widgetData);
        return const SizedBox.shrink();
      case 'Dropdown':
        return dropdownComponent(data: widgetData);
      case 'Obx':
        return obxComponent(data: widgetData);
      case 'Drag':
        return dragComponent(data: widgetData);
      case 'Drop':
        return dropComponent(
          data: widgetData,
          onAccept: Get.find<EditorController>().addWidget, // <- delegate
        );
      case 'TabBar':
        return tabBarComponent(data: widgetData);
      case 'Checkbox':
        return checkboxComponent(data: widgetData);

      // children widget
      case 'Column':
        return columnComponent(data: widgetData);
      case 'Row':
        return rowComponent(data: widgetData);
      case 'RowList':
        return rowListComponent(data: widgetData);
      case 'ColumnList':
        return columnListComponent(data: widgetData);
      case 'ListView':
        return listViewComponent(data: widgetData);
      case 'Stack':
        return stackComponent(data: widgetData);
      case 'Wrap':
        return wrapComponent(data: widgetData);
      case 'FlexibleWrap':
        return flexibleWrapComponent(data: widgetData);

      // Add more cases for different widget types...
      default:
        return SizedBox.shrink(); // Empty widget for unrecognized types
    }
  }
}

extension NumExtension on num? {
  double toDoubleOrZero() {
    return this?.toDouble() ?? 0.0;
  }
}
