import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';


popupComponent({
  required Widget widget,
  List<Widget>? actionButton,
  Function()? action,
  bool isError = false,
}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: isError ? Color(0xFFF9F0F1) : Color(0xFFD7F7EC),
        content: Container(
          // width: responseWidth(context),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              widget,
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: actionButton != null
            ? actionButton
            : [
                TextButton(
                  onPressed: () {
                    // Action to close the dialog
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Close', style: TextStyle(color: AppTheme.primary)),
                ),
                TextButton(
                  onPressed: () {
                    action!();
                  },
                  child: Text('Confirm',
                      style: TextStyle(color: AppTheme.primary)),
                ),
              ],
      );
    },
  );
}
