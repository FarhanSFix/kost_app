import 'package:get/get.dart';

import '../controllers/edit_property_controller.dart';

class EditPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPropertyController>(
      () => EditPropertyController(),
    );
  }
}
