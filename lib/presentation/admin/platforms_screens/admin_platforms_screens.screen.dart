import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../../dynamic/component/small_screen.dart';
import 'controllers/admin_platforms_screens.controller.dart';

class AdminPlatformsScreensScreen
    extends GetView<AdminPlatformsScreensController> {
  const AdminPlatformsScreensScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: smallScreen(
        child: Obx(() {
          return controller.buildBody(screenWidth);
        }),
      ),
    );
  }
}
