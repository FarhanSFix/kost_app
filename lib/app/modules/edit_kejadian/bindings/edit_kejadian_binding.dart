import 'package:get/get.dart';

import '../controllers/edit_kejadian_controller.dart';

class EditKejadianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditKejadianController>(
      () => EditKejadianController(),
    );
  }
}
