import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:startfront_app/infrastructure/theme/app_theme.dart';

class HandleError {
  static bool _isErrorShown = false;

  static void errors(String error, String name, String message) async {
    if (!_isErrorShown) {
      _isErrorShown = true; // Set flag to true to prevent duplicate alerts
      switch (error) {
        case '400_FAILED':
          errorScackbar(
            Get.context!,
            title: 'Invalid',
            message: error,
          );
          break;
        case '401_TOKEN_EPX':
          errorScackbar(
            Get.context!,
            title: 'Invalid',
            message: 'Token has been expired',
          );
          break;
        case '403_BAD_SERVICE':
          errorScackbar(
            Get.context!,
            title: 'Invalid',
            message: 'Internal Server Error',
          );
          break;
        case 'ERROR_I_C':
          errorScackbar(
            Get.context!,
            title: 'Invalid',
            message: 'Check internet connection',
          );
          break;
        default:
          errorScackbar(
            Get.context!,
            title: name,
            message: message,
          );
          break;
      }
      EasyLoading.dismiss();
    }
  }

  static void resetErrorFlag() {
    _isErrorShown = false; // Reset the error flag when needed, e.g., after successful actions or a new API call
  }
}

errorScackbar(
  BuildContext context, {
  String title = 'Something Wrong!',
  String message = 'Please check your internet connection',
}) {
  return Get.snackbar(
    maxWidth: 500,
    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    duration: const Duration(seconds: 3),
    backgroundColor: AppTheme.error,
    title,
    message,
    colorText: AppTheme.onPrimary,
  );
}

successScackbar(
  BuildContext context, {
  String title = 'Title',
  String message = 'Message',
}) {
  return Get.snackbar(
    maxWidth: 500,
    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    duration: const Duration(seconds: 3),
    backgroundColor: AppTheme.success,
    title,
    message,
    colorText: AppTheme.onPrimary,
  );
}
