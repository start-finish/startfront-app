import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/small_screen.dart';
import 'controllers/admin_widget_management.controller.dart';

class AdminWidgetManagementScreen
    extends GetView<AdminWidgetManagementController> {
  const AdminWidgetManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: smallScreen(child: controller.buildBody()),
    );
  }
}
