import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app_theme.dart';
import '../../infrastructure/util/dismiss_keyboad.dart';
import 'controllers/editor.controller.dart';


class EditorScreen extends GetView<EditorController> {
  const EditorScreen({super.key});
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
