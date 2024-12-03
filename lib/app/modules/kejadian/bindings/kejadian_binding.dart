import 'package:get/get.dart';

import '../controllers/kejadian_controller.dart';

class KejadianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KejadianController>(
      () => KejadianController(),
    );
  }
}
