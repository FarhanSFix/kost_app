import 'package:get/get.dart';

import '../controllers/edit_pengeluaran_controller.dart';

class EditPengeluaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPengeluaranController>(
      () => EditPengeluaranController(),
    );
  }
}
