import 'package:get/get.dart';

import '../controllers/edit_room_controller.dart';

class EditRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRoomController>(
      () => EditRoomController(),
    );
  }
}
