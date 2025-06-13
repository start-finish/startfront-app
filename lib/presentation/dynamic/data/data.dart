import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'factory.dart';

class DynamicWidgetData {
  String type;
  RxMap<String, dynamic> properties; // Use RxMap for reactivity
  DynamicWidgetData? _child;
  List<DynamicWidgetData> _children = [];

  DynamicWidgetData({
    required this.type,
    Map<String, dynamic> properties = const {},
    DynamicWidgetData? child,
    List<DynamicWidgetData>? children,
  }) : properties = RxMap<String, dynamic>(properties) {
    if (type == 'SnackBar') {
      DynamicWidgetFactory.createWidget(this);
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

  // Converts DynamicWidgetData to an actual Widget using DynamicWidgetFactory
  Widget toWidget() => Obx(() {
        return DynamicWidgetFactory.createWidget(this);
      });

  Map<String, dynamic> toJson() => {
        'type': type,
        'properties': properties,
        'child': _child?.toJson(),
        'children': _children.map((child) => child.toJson()).toList(),
      };

  String toJsonString() => jsonEncode(this.toJson());
}
