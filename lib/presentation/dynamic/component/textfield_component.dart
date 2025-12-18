import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startfront_app/infrastructure/theme/app_theme.dart';
import '../data/data.dart';

/// 🔁 Reusable text field with internal validation
Widget textFieldComponent({required DynamicWidgetData data}) {
  // Ensure the controller and focus node are initialized
  data.properties['controller'] ??= TextEditingController();
  data.properties['focusNode'] ??= FocusNode();
  data.properties['errorText'] ??= '';
  data.properties['showError'] ??= false.obs; // Ensure it's reactive with GetX

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: (data.properties['verticalPadding'] as num?)?.toDouble() ?? 0.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.properties['label'] != null)
          Obx(() {
            // Wrap in Obx to trigger UI update
            return Text(
              data.properties['label'],
              style: TextStyle(
                color: data.properties['showError'].value == true
                    ? AppTheme.error
                    : data.properties['labelColor'] ?? AppTheme.primary,
                fontSize: 13,
                fontWeight: data.properties['showError'].value == true
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            );
          }),
        if (data.properties['label'] != null) const SizedBox(height: 4),
        TextField(
          controller: data.properties['controller'],
          focusNode: data.properties['focusNode'],
          textInputAction: data.properties['nextFocus'] != null
              ? TextInputAction.next
              : TextInputAction.done,
          decoration: InputDecoration(
            hintText: data.properties['hintText'] ?? 'Enter text',
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            errorText: (data.properties['showError'].value == true &&
                    (data.properties['errorText'] as String?)?.isNotEmpty ==
                        true)
                ? data.properties['errorText']
                : null,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: data.properties['borderColor'] ?? AppTheme.error),
              borderRadius: BorderRadius.circular(
                (data.properties['borderRadius'] as num?)?.toDouble() ?? 12,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: data.properties['borderColor'] ?? AppTheme.error),
              borderRadius: BorderRadius.circular(
                (data.properties['borderRadius'] as num?)?.toDouble() ?? 12,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: data.properties['borderColor'] ?? AppTheme.primary),
              borderRadius: BorderRadius.circular(
                (data.properties['borderRadius'] as num?)?.toDouble() ?? 12,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: data.properties['borderColor'] ?? AppTheme.primary),
              borderRadius: BorderRadius.circular(
                (data.properties['borderRadius'] as num?)?.toDouble() ?? 12,
              ),
            ),
            prefixIcon: data.properties['prefixIcon'] != null
                ? Icon(
                    data.properties['prefixIcon'],
                    color: data.properties['color'] ?? AppTheme.onBackground,
                  )
                : null,
            filled: true,
            fillColor: AppTheme.onPrimary,
          ),
          maxLines: data.properties['maxLines'] ?? 1,
          minLines: data.properties['minLines'] ?? 1,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onChanged: (value) {
            data.properties['value'] = value;
            // Trigger validation when value changes
            _internalValidate(data);

            // Hide error if field is valid and required
            if (data.properties['isRequired'] == true &&
                value.trim().isNotEmpty) {
              data.properties['errorText'] = '';
              data.properties['showError'].value =
                  false; // Update the reactive state
            }
          },
          onSubmitted: (value) {
            data.properties['value'] = value;
            _internalValidate(data); // Run validation internally

            if (data.properties['onSubmitted'] != null) {
              data.properties['onSubmitted']!(value);
            }

            if (data.properties['nextFocus'] is FocusNode) {
              FocusScope.of(Get.context!)
                  .requestFocus(data.properties['nextFocus']);
            } else {
              FocusScope.of(Get.context!).unfocus();
            }
          },
        ),
      ],
    ),
  );
}

/// 🔍 Internal validation logic
bool _internalValidate(DynamicWidgetData data) {
  final controller = data.properties['controller'] as TextEditingController?;
  final isRequired = data.properties['isRequired'] == true;
  final isEmpty = controller?.text.trim().isEmpty ?? true;

  if (isRequired && isEmpty) {
    data.properties['errorText'] = 'This field is required';
    data.properties['showError'].value = true; // Ensure the error is reactive
    return false;
  } else {
    data.properties['errorText'] = '';
    data.properties['showError'].value =
        false; // Reset the error message reactively
    return true;
  }
}

/// 🔔 Bonus: Call this from outside (on Submit button)
bool validateField(DynamicWidgetData data) {
  return _internalValidate(data);
}
