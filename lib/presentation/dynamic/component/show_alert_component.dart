import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';
import '../data/factory.dart';

showAlertComponent({required DynamicWidgetData data}) {
  final props = data.properties;

  // Determine body: message or content
  Widget? contentWidget;
  if (props['content'] != null && props['content'] is DynamicWidgetData) {
    contentWidget = DynamicWidgetFactory.createWidget(props['content']);
  }

  final messageWidget =
      props['message'] != null ? Text(props['message']) : null;

  Get.dialog(
    AlertDialog(
      title: props['title'] != null
          ? Text(props['title'],
              style: const TextStyle(fontWeight: FontWeight.bold))
          : null,
      content: contentWidget ?? messageWidget,
      backgroundColor: AppTheme.onPrimary,
      actions: [
        if (props['cancelText'] != null)
          TextButton(
            onPressed: () {
              final func = props['onCancel'];
              if (func is Function) func();
              Get.back();
            },
            child: Text(props['cancelText']),
          ),
        if (props['confirmText'] != null)
          ElevatedButton(
            onPressed: () {
              final func = props['onConfirm'];
              if (func is Function) func();
              Get.back();
            },
            child: Text(props['confirmText']),
          ),
      ],
    ),
    barrierDismissible: props['dismiss'] ?? true,
  );
}
