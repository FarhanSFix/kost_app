import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahKejadianController extends GetxController {
  final namaPenghuni = RxnString();
  final kejadian = ''.obs;
  final nominal = ''.obs;
  final bukti = RxnString();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void simpanData() {
    if (formKey.currentState!.validate()) {
      Get.toNamed('/kejadian');
      Get.snackbar(
        "Sukses",
        "Data kejadian berhasil disimpan",
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