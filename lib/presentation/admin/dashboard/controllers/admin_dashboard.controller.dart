import 'package:get/get.dart';

import '../../../../infrastructure/theme/app_theme.dart';
import '../../../dynamic/component/logo_label.dart';
import '../../../dynamic/data/data.dart';

class AdminDashboardController extends GetxController {
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
      type: 'Column',
      properties: {'mainAxisSize': 'max'},
      children: [
        DynamicWidgetData(
          type: 'AppBar',
          properties: {
            'isBack': false,
            'isHome': false,
            'gradient': 'secondary',
            'height': 80,
            'maxWidth': 1000,
            'titleColor': AppTheme.onPrimary,
            'leading': logoLabel(
              subTitle: 'Admin Control Managment',
              backgroundColor: AppTheme.onPrimary.withOpacity(0.8),
              isMainAxisSize: 'min',
            ).toWidget(),
          },
        ),
        DynamicWidgetData(
          type: 'Center',
          properties: {},
          child: DynamicWidgetData(
            type: 'Container',
            properties: {
              'color': AppTheme.background,
              'maxWidth': 1000,
            },
            child: DynamicWidgetData(type: 'Text'),
          ),
        ),
      ],
    ).toWidget();
  }
}
