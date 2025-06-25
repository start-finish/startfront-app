import 'package:get/get.dart';

import '../../../../presentation/editor/controllers/editor.controller.dart';

class EditorControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditorController>(
      () => EditorController(),
    );
  }
}
