import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class AddPropertyController extends GetxController {
  final namePropertyController = TextEditingController();
  final nameManagerController = TextEditingController();
  final telpManagerController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtPropertyController = TextEditingController();
  final detailAddressPropertyController = TextEditingController();
  var isLoading = false.obs;

  void addProperty({
    required String namaProperti,
    required String namaPengelola,
    required String detailAlamat,
    required String kabupaten,
    required String kecamatan,
    required String provinsi,
    required String teleponPengelola,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (namaProperti.isEmpty ||
          namaPengelola.isEmpty ||
          teleponPengelola.isEmpty ||
          provinsi.isEmpty ||
          kabupaten.isEmpty ||
          kecamatan.isEmpty ||
          detailAlamat.isEmpty) {
        Get.snackbar(
          'Error',
          'Semua kolom wajib diisi!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection('properti').add({
            'created_at': DateTime.now(),
            'nama_properti': namaProperti,
            'nama_pengelola': namaPengelola,
            'detail_alamat': detailAlamat,
            'kabupaten': kabupaten,
            'kecamatan': kecamatan,
            'provinsi': provinsi,
            'telepon_pengelola': teleponPengelola,
            'userId': user.uid,
          });

          Get.snackbar(
            'Sukses',
            'Properti berhasil ditambahkan!',
          );
          Get.offAllNamed(Routes.PROPERTY);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal menambahkan properti: $e',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan properti${e}");
    } finally {
      isLoading.value = false;
    }
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
