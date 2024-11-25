import 'package:get/get.dart';

import '../controllers/detail_property_controller.dart';

class DetailPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPropertyController>(
      () => DetailPropertyController(),
    );
  }
}
