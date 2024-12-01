import 'package:get/get.dart';

import '../controllers/add_penghuni_controller.dart';

class AddPenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPenghuniController>(
      () => AddPenghuniController(),
    );
  }
}
