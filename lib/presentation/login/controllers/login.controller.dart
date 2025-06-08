import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../domain/service/dynamic_fetch_data.dart';
import '../../../domain/service/dynamic_service.dart';
import '../../../domain/service/handle_error.dart';
import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/logo_label.dart';
import '../../dynamic/component/textfield_component.dart';
import '../../dynamic/data/data.dart';

class LoginController extends GetxController {
  final emailTF = TextEditingController();
  final passwordTF = TextEditingController();

  final emailFN = FocusNode();
  final passwordFN = FocusNode();

  late DynamicWidgetData emailField;
  late DynamicWidgetData passwordField;

  @override
  void onInit() {
    super.onInit();

    emailTF.text = '';
    passwordTF.text = '';

    emailField = DynamicWidgetData(
      type: 'TextField',
      properties: {
        'label': 'Email',
        'controller': emailTF,
        'focusNode': emailFN,
        'nextFocus': passwordFN,
        'hintText': 'Enter email',
        'isRequired': true,
        'errorText': '',
        'showError': false,
      },
    );

    passwordField = DynamicWidgetData(
      type: 'TextField',
      properties: {
        'label': 'Password',
        'controller': passwordTF,
        'focusNode': passwordFN,
        'hintText': 'Enter password',
        'isRequired': true,
        'errorText': '',
        'showError': false,
      },
    );
  }

  @override
  void onClose() {
    emailTF.dispose();
    passwordTF.dispose();
    emailFN.dispose();
    passwordFN.dispose();
    super.onClose();
  }

  Future<void> fetchLogin() async {
    // First validate required fields
    final emailValid = validateField(emailField);
    final passValid = validateField(passwordField);

    update();

    if (!emailValid || !passValid) return;

    EasyLoading.show(status: 'Logging in...');

    final dataFetcher = DynamicFetchData(dynamicService: DynamicService());

    final reqBody = {
      'username': emailTF.text.trim(),
      'password': passwordTF.text.trim(),
    };

    final result = await dataFetcher.dynamicFetchData(
      name: 'Login',
      reqBody: reqBody,
      subEndpoint: 'login',
      isLoading: false,
    );

    EasyLoading.dismiss();

    result.fold(
      (error) => HandleError.errors(error, 'Login', error),
      (data) {
        successScackbar(
          Get.context!,
          title: 'Login',
          message: data['message'],
        );
        Get.offAllNamed('/admin-dashboard');
      },
    );
  }

  buildBody() {
    return DynamicWidgetData(
      type: 'Container',
      properties: {
        'width': Get.width,
        'gradient': 'secondary',
      },
      child: DynamicWidgetData(
        type: 'Center',
        child: DynamicWidgetData(
          type: 'Container',
          properties: {
            'width': 350,
            'alignment': 'center',
            'color': AppTheme.onSecondary,
            'padding': 16,
            'radius': 16,
            'margin': 16,
          },
          child: DynamicWidgetData(
            type: 'Column',
            properties: {
              'mainAxisSize': 'min',
              'mainAxisAlignment': 'center',
              'crossAxisAlignment': 'center',
              'spacing': 12,
            },
            children: [
              DynamicWidgetData(type: 'SizedBox', properties: {'height': 6}),
              logoLabel(subTitle: 'Visual Flutter Builder'),
              DynamicWidgetData(type: 'SizedBox', properties: {'height': 10}),
              emailField,
              passwordField
                ..properties['onSubmitted'] =
                    (value) async => await Get.offAllNamed('/admin-dashboard'),
              // (value) async => await fetchLogin(),
              DynamicWidgetData(type: 'SizedBox', properties: {'height': 8}),
              DynamicWidgetData(
                type: 'Button',
                properties: {
                  'color': AppTheme.primary,
                  'width': double.infinity,
                  'title': 'Sign In',
                  'titleColor': AppTheme.onPrimary,
                  'svgIcon': 'assets/svg/log-in.svg',
                  'svgColor': AppTheme.onPrimary,
                  'padding': 8,
                  'radius': 12,
                  'action': () async =>
                      await Get.offAllNamed('/admin-dashboard'),
                  // 'action': () async => await fetchLogin(),
                },
              ),
              DynamicWidgetData(type: 'SizedBox', properties: {'height': 2}),
              DynamicWidgetData(
                type: 'Text',
                properties: {
                  'text': 'Forget your password?',
                  'fontWeight': 'bold',
                  'color': AppTheme.primary,
                  'fontSize': 12,
                },
              ),
              DynamicWidgetData(
                type: 'Row',
                children: [
                  DynamicWidgetData(
                    type: 'Text',
                    properties: {
                      'text': 'Don\'t have an account? ',
                      'fontSize': 12,
                    },
                  ),
                  DynamicWidgetData(
                    type: 'Button',
                    properties: {
                      'action': () => Get.offAllNamed('/signup'),
                    },
                    child: DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text': 'Sign up',
                        'fontWeight': 'bold',
                        'color': AppTheme.primary,
                        'fontSize': 12,
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).toWidget();
  }
}
