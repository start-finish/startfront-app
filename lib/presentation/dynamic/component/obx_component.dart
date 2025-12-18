import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data.dart';
import '../data/factory.dart';

obxComponent({required DynamicWidgetData data}) {
  final builder = data.properties['builder'];

  if (builder != null && builder is Function) {
    return Obx(() {
      final result = builder(); // must be DynamicWidgetData
      if (result is DynamicWidgetData) {
        return DynamicWidgetFactory.createWidget(result);
      }
      return const SizedBox.shrink();
    });
  }

  return const SizedBox.shrink();
}
