import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

Widget checkboxComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  // Correctly initialize RxBool using the value from the property
  final isChecked =
      property['initialValue'] ??
      false.obs; // Ensure obs is called on a boolean value

  final onChanged = property['onChanged'];

  // Styling
  final label = property['label'] ?? 'Checkbox Label';
  final title = property['title'] ?? 'Checkbox Title';
  final labelColor = property['labelColor'] ?? AppTheme.onBackground;
  final checkboxColor = property['checkboxColor'] ?? AppTheme.onBackground;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
      const SizedBox(height: 8),
      Obx(() {
        // Wrap checkbox in Obx to update when isChecked changes
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              key: property['key'] != null ? Key(property['key']) : null,
              value: isChecked.value,
              onChanged: (bool? value) {
                isChecked.value = value ?? false;
                // Call onChanged callback if provided
                if (onChanged is Function) {
                  onChanged(isChecked.value);
                }
              },
              activeColor: checkboxColor,
            ),
            if (title != null)
              Text(
                title ?? '',
                style: TextStyle(color: labelColor, fontSize: 14),
              ),
          ],
        );
      }),
    ],
  );
}
