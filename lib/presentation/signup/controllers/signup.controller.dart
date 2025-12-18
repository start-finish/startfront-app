import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/logo_label.dart';
import '../../dynamic/data/data.dart';

class SignupController extends GetxController {
  final fullNameTF = TextEditingController();
  final emailTF = TextEditingController();
  final passwordTF = TextEditingController();
  final confirmPasswordTF = TextEditingController();

  final fullNameFN = FocusNode();
  final emailFN = FocusNode();
  final passwordFN = FocusNode();
  final confirmPasswordFN = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Future<void> fetchLogin() async {
  //   final dataFetcher = DynamicFetchData(dynamicService: DynamicService());

  //   // Build your request body
  //   final reqBody = {
  //     'username': tf.text.trim(),
  //     'password': passwordTF.text.trim(),
  //   };

  //   // Call the dynamicFetchData method
  //   final result = await dataFetcher.dynamicFetchData(
  //     name: 'Login',
  //     reqBody: reqBody,
  //     subEndpoint: 'login',
  //   );

  //   result.fold(
  //     (error) {
  //       // Handle error here
  //       print('Login error: $error');
  //       Get.snackbar('Error', error);
  //     },
  //     (data) {
  //       // Handle success data here
  //       Get.snackbar('Success', 'Logged in successfully');
  //     },
  //   );
  // }

  buildBody() {
    return DynamicWidgetData(
      type: 'Container',
      properties: {
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
              // NOTE: logo label
              logoLabel(
                subTitle: 'Create your account',
              ),
              DynamicWidgetData(
                type: 'SizedBox',
                properties: {'height': 16},
              ),
              // NOTE: full name textfield
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Full Name',
                  'controller': fullNameTF,
                  'focusNode': fullNameFN,
                  'nextFocus': emailFN,
                  'hintText': 'Enter full name',
                },
              ),
              // NOTE: email textfield
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Email',
                  'controller': emailTF,
                  'focusNode': emailFN,
                  'nextFocus': passwordFN,
                  'hintText': 'Enter email',
                },
              ),
              // NOTE: password textfield
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Password',
                  'controller': passwordTF,
                  'focusNode': passwordFN,
                  'nextFocus': confirmPasswordFN,
                  'hintText': 'Create a password',
                },
              ),
              DynamicWidgetData(
                type: 'TextField',
                properties: {
                  'label': 'Confirm Password',
                  'controller': confirmPasswordTF,
                  'nextFocus': confirmPasswordFN,
                  'hintText': 'Confirm your password',
                  'onSubmitted': (value) async {
                    // TODO:
                    // await fetchLogin();
                  }
                },
              ),
              DynamicWidgetData(
                type: 'SizedBox',
                properties: {'height': 8},
              ),
              // NOTE: register button
              DynamicWidgetData(
                type: 'Button',
                properties: {
                  'color': AppTheme.primary,
                  'width': double.infinity,
                  'title': 'Create Account',
                  'titleColor': AppTheme.onPrimary,
                  'textColor': AppTheme.onPrimary,
                  'padding': 8,
                  'radius': 12,
                  'svgIcon': 'assets/svg/sign-up.svg',
                  'svgColor': AppTheme.onPrimary,
                  'action': () async {
                    // TODO:
                    // await fetchLogin();
                  }
                },
              ),
              DynamicWidgetData(
                type: 'SizedBox',
                properties: {'height': 2},
              ),
              DynamicWidgetData(
                type: 'Row',
                properties: {},
                children: [
                  DynamicWidgetData(
                    type: 'Text',
                    properties: {
                      'text': 'Already have an account? ',
                      'fontSize': 12,
                    },
                  ),
                  DynamicWidgetData(
                    type: 'Button',
                    properties: {
                      'borderColor': Colors.transparent,
                      'hoverBorderColor': Colors.transparent,
                      'hoverColor': Colors.transparent,
                      'hoverBorderWidth': 0,
                      'action': () => Get.offAllNamed('/login')
                    },
                    child: DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text': 'Sign in',
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
