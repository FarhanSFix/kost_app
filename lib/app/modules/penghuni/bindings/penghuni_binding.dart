import 'package:get/get.dart';

import '../controllers/penghuni_controller.dart';

class PenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenghuniController>(
      () => PenghuniController(),
    );
  }
}
