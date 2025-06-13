import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';

OverlayEntry? _snackbarOverlay;

void showSnackbarComponent({required DynamicWidgetData data}) {
  final property = data.properties;

  final overlay = Overlay.of(Get.context!);
  if (overlay == null) return;

  // Remove previous snackbar if still on screen
  _snackbarOverlay?.remove();

  _snackbarOverlay = OverlayEntry(
    builder: (context) => Positioned(
      top: 30,
      right: 30,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.success,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
          child: Row(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/svg/check-double.svg',
                color: property['color'] ?? AppTheme.onPrimary,
                width: property['width'] ?? 24,
                height: property['height'] ?? 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property['message'] ?? 'No Message',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(_snackbarOverlay!);

  Future.delayed(const Duration(seconds: 3), () {
    _snackbarOverlay?.remove();
    _snackbarOverlay = null;
  });
}
