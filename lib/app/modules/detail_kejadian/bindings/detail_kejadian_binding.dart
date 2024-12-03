import 'package:get/get.dart';

import '../controllers/detail_kejadian_controller.dart';

class DetailKejadianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailKejadianController>(
      () => DetailKejadianController(),
    );
  }
}
