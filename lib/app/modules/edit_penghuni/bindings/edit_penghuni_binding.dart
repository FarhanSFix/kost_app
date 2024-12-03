import 'package:get/get.dart';

import '../controllers/edit_penghuni_controller.dart';

class EditPenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPenghuniController>(
      () => EditPenghuniController(),
    );
  }
}
