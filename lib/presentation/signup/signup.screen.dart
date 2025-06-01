import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app_theme.dart';
import '../../infrastructure/util/dismiss_keyboad.dart';
import 'controllers/signup.controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: controller.buildBody(),
      ),
    );
  }
}
