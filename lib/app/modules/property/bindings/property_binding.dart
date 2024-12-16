import 'package:get/get.dart';

import '../controllers/property_controller.dart';

class PropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PropertyController>(
      () => PropertyController(),
    );
  }
}
