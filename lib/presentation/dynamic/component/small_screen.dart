import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_theme.dart';
import '../data/data.dart';
import 'logo_label.dart';

smallScreen({required Widget child}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 1000;

      return isSmallScreen
          ? DynamicWidgetData(
              type: 'Container',
              properties: {
                'gradient': 'primary',
                'height': Get.height,
              },
              child: DynamicWidgetData(
                type: 'Scroll',
                properties: {},
                child: DynamicWidgetData(
                  type: 'Column',
                  properties: {
                    'mainAxisSize': 'max',
                    'crossAxisAlignment': 'center',
                  },
                  children: [
                    DynamicWidgetData(
                      type: 'Container',
                      properties: {
                        'color': AppTheme.surface,
                        'leftMargin': 16,
                        'topMargin': 16,
                        'rightMargin': 16,
                        'radius': 16,
                      },
                      child: DynamicWidgetData(
                        type: 'AppBar',
                        properties: {
                          'isBack': false,
                          'isHome': false,
                          'height': 80,
                          'maxWidth': 1280,
                          'titleColor': AppTheme.onPrimary,
                          'leading': logoLabel(
                            subTitle: 'Admin Control Managment',
                            isMainAxisSize: 'min',
                          ).toWidget(),
                        },
                      ),
                    ),
                    DynamicWidgetData(
                      type: 'Container',
                      properties: {
                        'horizontalPadding': 64,
                        'minWidth': 100,
                        'maxWidth': 600,
                      },
                      child: DynamicWidgetData(
                        type: 'Image',
                        properties: {
                          'image': 'assets/logo/small_screen.png',
                        },
                      ),
                    ),
                    DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text': 'Windows too small',
                        'fontSize': 32,
                        'fontWeight': 'bold',
                        'color': AppTheme.onPrimary,
                      },
                    ),
                    DynamicWidgetData(
                      type: 'Text',
                      properties: {
                        'text':
                            'You\'re signed in, but your screen is too small to use StartFront.\nPlease use a desktop or tablet.',
                        'fontSize': 16,
                        'maxLines': 5,
                        'textAlign': TextAlign.center,
                        'color': AppTheme.onPrimary,
                      },
                    ),
                    DynamicWidgetData(
                      type: 'SizedBox',
                      properties: {'height': 32},
                    ),
                  ],
                ),
              ),
            ).toWidget()
          : child;
    },
  );
}
