import 'package:get/get.dart';

import '../controllers/edit_pemasukan_controller.dart';

class EditPemasukanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPemasukanController>(
      () => EditPemasukanController(),
    );
  }
}
