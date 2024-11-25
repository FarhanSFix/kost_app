import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPropertyController extends GetxController {
  final namePropertyController = TextEditingController();
  final nameManagerController = TextEditingController();
  final telpManagerController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtPropertyController = TextEditingController();
  final detailAddressPropertyController = TextEditingController();

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
