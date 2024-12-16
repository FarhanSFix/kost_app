import 'package:get/get.dart';

import '../controllers/detail_pengeluaran_controller.dart';

class DetailPengeluaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengeluaranController>(
      () => DetailPengeluaranController(),
    );
  }
}
