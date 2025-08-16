// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'factory.dart';

// class DynamicWidgetData {
//   String type;
//   RxMap<String, dynamic> properties; // Use RxMap for reactivity
//   DynamicWidgetData? _child;
//   List<DynamicWidgetData> _children = [];

//   DynamicWidgetData({
//     required this.type,
//     Map<String, dynamic> properties = const {},
//     DynamicWidgetData? child,
//     List<DynamicWidgetData>? children,
//   }) : properties = RxMap<String, dynamic>(properties) {
//     if (type == 'SnackBar' || type == 'Alert') {
//       Future.delayed(Duration.zero, () {
//         DynamicWidgetFactory.createWidget(this);
//       });
//     }
//     if (child != null) {
//       _child = child;
//       _children = [];
//     } else if (children != null && children.isNotEmpty) {
//       _children = List.from(children);
//       _child = null;
//     }
//   }

//   DynamicWidgetData? get child => _child;
//   List<DynamicWidgetData> get children => _children;

//   set child(DynamicWidgetData? value) {
//     _child = value;
//     if (value != null) {
//       _children = [];
//     }
//   }

//   set children(List<DynamicWidgetData> value) {
//     _children = List.from(value);
//     if (value.isNotEmpty) {
//       _child = null;
//     }
//   }

//   // Converts DynamicWidgetData to an actual Widget using DynamicWidgetFactory
//   Widget toWidget() => Obx(() {
//         return DynamicWidgetFactory.createWidget(this);
//       });

//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'properties': properties,
//         'child': _child?.toJson(),
//         'children': _children.map((child) => child.toJson()).toList(),
//       };

//   String toJsonString() => jsonEncode(this.toJson());
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'factory.dart'; // Your widget builder logic

class DynamicWidgetData {
  String id;
  String type;
  RxMap<String, dynamic> properties;
  RxBool selected = false.obs; // New: for selection highlighting

  DynamicWidgetData? _child;
  List<DynamicWidgetData> _children = [];

  DynamicWidgetData({
    String? id,
    required this.type,
    Map<String, dynamic> properties = const {},
    DynamicWidgetData? child,
    List<DynamicWidgetData>? children,
  })  : id = id ?? 'widget_${DateTime.now().millisecondsSinceEpoch}',
        properties = RxMap<String, dynamic>(properties) {
    if (type == 'SnackBar' || type == 'Alert') {
      Future.delayed(Duration.zero, () {
        DynamicWidgetFactory.createWidget(this);
      });
    }
    if (child != null) {
      _child = child;
      _children = [];
    } else if (children != null && children.isNotEmpty) {
      _children = List.from(children);
      _child = null;
    }
  }

  DynamicWidgetData? get child => _child;
  List<DynamicWidgetData> get children => _children;

  set child(DynamicWidgetData? value) {
    _child = value;
    if (value != null) {
      _children = [];
    }
  }

  set children(List<DynamicWidgetData> value) {
    _children = List.from(value);
    if (value.isNotEmpty) {
      _child = null;
    }
  }

  /// Wrap with Obx so any property/selection change triggers UI rebuild
  Widget toWidget({
    void Function()? onSelect,
    void Function()? onDuplicate,
    void Function()? onDelete,
  }) =>
      Obx(() {
        final childWidget = DynamicWidgetFactory.createWidget(this);
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (onSelect != null) onSelect();
              },
              child: Container(
                decoration: selected.value
                    ? BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: childWidget,
              ),
            ),
            if (selected.value)
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: onDuplicate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
          ],
        );
      });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'properties': properties,
        'child': _child?.toJson(),
        'children': _children.map((child) => child.toJson()).toList(),
      };

  String toJsonString() => jsonEncode(this.toJson());

  DynamicWidgetData clone() {
    return DynamicWidgetData(
      type: type,
      properties: Map<String, dynamic>.from(properties),
      child: _child?.clone(),
      children: _children.map((c) => c.clone()).toList(),
    );
  }
}
