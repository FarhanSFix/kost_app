import 'package:get/get.dart';
import 'package:kost_app/app/modules/history/controllers/history_controller.dart';
import 'package:kost_app/app/modules/home/controllers/home_controller.dart';
import 'package:kost_app/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
  }
}
