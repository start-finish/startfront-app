import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../app/controllers/theme_controller.dart';
import '../../infrastructure/theme/app_theme.dart';
import 'controllers/settings.controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: AppTheme.primary,
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  ThemeController.to.toggleTheme();
                },
                child: Text(
                  AppTheme.isDark ? 'Switch to Light' : 'Switch to Dark',
                ),
              ),
              Container(
                width: 100,
                height: 100,
                color: AppTheme.surface,
              )
            ],
          ),
        ),
      ),
    );
  }
}
