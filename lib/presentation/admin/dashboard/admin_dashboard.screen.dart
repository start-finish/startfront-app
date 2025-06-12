import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/small_screen.dart';
import 'controllers/admin_dashboard.controller.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: smallScreen(child: controller.buildBody()),
    );
  }
}
