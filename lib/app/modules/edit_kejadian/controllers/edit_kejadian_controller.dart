import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditKejadianController extends GetxController {
  final namaPenghuni = "Farhan".obs;
  final kejadian = "Membuang Sampah Sembarangan".obs;
  final nominal = "5000".obs;
  final bukti = RxnString();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  void perbaruiData() {
    if (formKey.currentState!.validate()) {
      Get.toNamed('/detail-kejadian');
      Get.snackbar(
        "Sukses",
        "Data kejadian berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Gagal",
        "Mohon lengkapi semua data",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}