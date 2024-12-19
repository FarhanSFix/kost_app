import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class EditPropertyController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final property = Get.arguments;
  var isLoading = false.obs;

  Future<DocumentSnapshot<Object?>> getProperty(String docId) async {
    DocumentReference docref = firestore.collection('properti').doc(docId);
    return docref.get();
  }

  final namePropertyController = TextEditingController();
  final nameManagerController = TextEditingController();
  final telpManagerController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtPropertyController = TextEditingController();
  final detailAddressPropertyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  void updateProperty({
    required String docId,
    required String namaProperti,
    required String namaPengelola,
    required String detailAlamat,
    required String kabupaten,
    required String kecamatan,
    required String provinsi,
    required String teleponPengelola,
  }) async {
    if (isLoading.value) return; // Jika masih loading, abaikan aksi baru
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
          await FirebaseFirestore.instance
              .collection('properti')
              .doc(docId)
              .update({
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
            'Properti berhasil diperbarui!',
          );
          Get.offAllNamed(Routes.DETAIL_PROPERTY, arguments: property);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal memperbarui properti: $e',
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
      Get.snackbar('Error', 'Gagal memperbarui data properti: $e');
    } finally {
      isLoading.value = false; // Pastikan loading di-reset
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
