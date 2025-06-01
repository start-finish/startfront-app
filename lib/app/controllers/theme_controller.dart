import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final themeMode = ThemeMode.dark.obs;

  static void init() {
    Get.put(ThemeController());
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('isDarkMode')) {
      final isDark = prefs.getBool('isDarkMode') ?? false; // fallback to light
      themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      // 💡 Default to light mode on first app launch
      themeMode.value = ThemeMode.light;
      await prefs.setBool('isDarkMode', false);
    }
  }

  Future<void> toggleTheme() async {
    final isDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', !isDark);
  }
}
