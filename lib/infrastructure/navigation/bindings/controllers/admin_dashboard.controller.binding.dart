import 'package:get/get.dart';

import '../../../../presentation/admin/dashboard/controllers/admin_dashboard.controller.dart';

class AdminDashboardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
    );
  }
}
