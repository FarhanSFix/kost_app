import 'package:get/get.dart';

import '../controllers/add_finance_controller.dart';

class AddFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFinanceController>(
      () => AddFinanceController(),
    );
  }
}
