import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPropertyController extends GetxController {
  final Map<String, dynamic> property = Get.arguments as Map<String, dynamic>;
  final namePropertyController = TextEditingController();
  final nameManagerController = TextEditingController();
  final telpManagerController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtPropertyController = TextEditingController();
  final detailAddressPropertyController = TextEditingController();

  @override
  void onInit() {
    namePropertyController.text = '${property['nameProperty']}';
    nameManagerController.text = '${property['managerProperty']}';
    telpManagerController.text = '${property['telpManagerProperty']}';
    provinceController.text = '${property['province']}';
    cityController.text = '${property['City']}';
    districtPropertyController.text = '${property['district']}';
    detailAddressPropertyController.text = '${property['addressDetail']}';
    super.onInit();
  }

  @override
  void onClose() {
    namePropertyController.dispose();
    nameManagerController.dispose();
    telpManagerController.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtPropertyController.dispose();
    detailAddressPropertyController.dispose();
    super.onClose();
  }
}
