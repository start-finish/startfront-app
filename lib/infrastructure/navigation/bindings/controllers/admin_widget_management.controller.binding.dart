import 'package:get/get.dart';

import '../../../../presentation/admin/widget_management/controllers/admin_widget_management.controller.dart';

class AdminWidgetManagementControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminWidgetManagementController>(
      () => AdminWidgetManagementController(),
    );
  }
}
