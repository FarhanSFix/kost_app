import 'package:get/get.dart';

class DetailPropertyController extends GetxController {
  // final property = Get.arguments;
  final Map<String, dynamic> property = Get.arguments as Map<String, dynamic>;
  final RxString selectedFilter = ''.obs;
  List<Map<String, dynamic>> get filteredRooms {
    if (selectedFilter.value.isEmpty) {
      return property['rooms'];
    } else {
      return property['rooms']
          .where((room) => room['status'] == selectedFilter.value)
          .toList();
    }
  }
}
