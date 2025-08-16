import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data.dart';

obxComponent({required DynamicWidgetData data}) {
  final builder = data.properties['builder'];
  if (builder != null && builder is Function) {
    return Obx(() => builder());
  }
  return const SizedBox.shrink();
}
