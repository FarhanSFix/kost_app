import 'package:get/get.dart';

import '../controllers/detail_pemasukan_controller.dart';

class DetailPemasukanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPemasukanController>(
      () => DetailPemasukanController(),
    );
  }
}
