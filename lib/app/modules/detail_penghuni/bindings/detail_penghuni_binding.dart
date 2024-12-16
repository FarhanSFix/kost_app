import 'package:get/get.dart';

import '../controllers/detail_penghuni_controller.dart';

class DetailPenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPenghuniController>(
      () => DetailPenghuniController(),
    );
  }
}
