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
    namePropertyController.text = '${property['nama_properti']}';
    nameManagerController.text = '${property['nama_pengelola']}';
    telpManagerController.text = '${property['telepon_pengelola']}';
    provinceController.text = '${property['provinsi']}';
    cityController.text = '${property['kabupaten']}';
    districtPropertyController.text = '${property['kecamatan']}';
    detailAddressPropertyController.text = '${property['detail_alamat']}';
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
