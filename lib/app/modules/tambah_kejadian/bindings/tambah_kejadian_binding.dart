import 'package:get/get.dart';

import '../controllers/tambah_kejadian_controller.dart';

class TambahKejadianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahKejadianController>(
      () => TambahKejadianController(),
    );
  }
}
