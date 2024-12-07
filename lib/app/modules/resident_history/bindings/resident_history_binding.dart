import 'package:get/get.dart';

import '../controllers/resident_history_controller.dart';

class ResidentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResidentHistoryController>(
      () => ResidentHistoryController(),
    );
  }
}
