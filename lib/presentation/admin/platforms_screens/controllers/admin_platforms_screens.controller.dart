import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/data/data.dart';

class AdminPlatformsScreensController extends GetxController {
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

  buildBody() {
    return DynamicWidgetData(
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
                  'isHome': false,
                  'height': 80,
                  'maxWidth': double.infinity,
                  'titleColor': AppTheme.onSurface,
                  'subTitleColor': AppTheme.onSurface,
                  'title': 'Platform Screens',
                  'subTitle': 'Manage and edit StartFront UI screens',
                  'action': [
                    DynamicWidgetData(
                      type: 'Button',
                      properties: {
                        'borderColor': AppTheme.onSurface,
                        'borderWidth': 1,
                        'title': 'New Screen',
                        'svgIcon': 'assets/svg/add.svg',
                        'svgIconColor': AppTheme.onPrimary,
                        'color': AppTheme.primary,
                        'textColor': AppTheme.onPrimary,
                        'horizontalPadding': 16,
                        'verticalPadding': 8,
                        'radius': 8,
                        'fontSize': 14,
                        'iconSize': 18,
                        'action': () => print('New Screen'),
                      },
                    ),
                  ],
                },
              ),
            ),
          ],
        ),
      ),
    ).toWidget();
  }
}
