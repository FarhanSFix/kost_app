import 'package:get/get.dart';

import '../controllers/add_kejadian_controller.dart';

class AddKejadianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddKejadianController>(
      () => AddKejadianController(),
    );
  }
}
