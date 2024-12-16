import 'package:get/get.dart';

import '../controllers/add_property_controller.dart';

class AddPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPropertyController>(
      () => AddPropertyController(),
    );
  }
}
