import 'package:get/get.dart';

import '../../../../presentation/admin/platforms_screens/controllers/admin_platforms_screens.controller.dart';

class AdminPlatformsScreensControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPlatformsScreensController>(
      () => AdminPlatformsScreensController(),
    );
  }
}
