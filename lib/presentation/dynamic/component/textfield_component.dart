import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startfront_app/infrastructure/theme/app_theme.dart';
import '../data/data.dart';

/// 🔁 Reusable text field with internal validation
Widget textFieldComponent({required DynamicWidgetData data}) {
  data.properties['controller'] ??= TextEditingController();
  data.properties['focusNode'] ??= FocusNode();
  data.properties['errorText'] ??= '';
  data.properties['showError'] ??= false;

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: (data.properties['verticalPadding'] as num?)?.toDouble() ?? 0.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.properties['label'] != null)
          Text(
            data.properties['label'],
            style: TextStyle(
              color: data.properties['showError']
                  ? AppTheme.error
                  : data.properties['labelColor'] ?? AppTheme.primary,
              fontSize: 13,
              fontWeight: data.properties['showError']
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
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
            errorText: (data.properties['showError'] == true &&
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
            // prefixIcon: data.properties['svgIcon'] != null
            //     ? SvgPicture.asset(
            //         data.properties['svgIcon'],
            //         color: data.properties['color'] ?? AppTheme.onBackground,
            //       )
            //     : null,
            prefixIcon: data.properties['prefixIcon'] != null
                ? Icon(
                    data.properties['prefixIcon'],
                    color: data.properties['color'] ?? AppTheme.onBackground,
                  )
                : null,
            // prefixIconConstraints: BoxConstraints(
            //   maxWidth: data.properties['width'] ?? 18,
            //   maxHeight: data.properties['height'] ?? 18,
            // ),
            filled: true,
            fillColor: AppTheme.onPrimary,
          ),
          maxLines: data.properties['maxLines'] ?? 1,
          minLines: data.properties['minLines'] ?? 1,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onChanged: (value) {
            data.properties['value'] = value;
            if (data.properties['isRequired'] == true &&
                value.trim().isNotEmpty) {
              data.properties['errorText'] = '';
              data.properties['showError'] = false;
            }
          },
          onSubmitted: (value) {
            data.properties['value'] = value;
            _internalValidate(data); // run validation internally

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
    data.properties['showError'] = true;
    return false;
  } else {
    data.properties['errorText'] = '';
    data.properties['showError'] = false;
    return true;
  }
}

/// 🔔 Bonus: Call this from outside (on Submit button)
bool validateField(DynamicWidgetData data) {
  return _internalValidate(data);
}
