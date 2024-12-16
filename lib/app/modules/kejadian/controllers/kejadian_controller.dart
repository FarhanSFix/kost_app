import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class KejadianController extends GetxController {
  var searchNama = ''.obs;
  var kejadianList = <Kejadian>[].obs;
  var penghuniList = <Penghuni>[].obs;
  var isLoading = true.obs;

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  void searchPenghuni(String keyword) {
    searchNama.value = keyword.toLowerCase();
    update();
  }

  void fetchPenghuni() async {
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final penghuniQuery =
            await FirebaseFirestore.instance.collection('penghuni').get();

        penghuniList.value = penghuniQuery.docs
            .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchKejadian() async {
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final kejadianQuery = await FirebaseFirestore.instance
            .collection('kejadian')
            .where("userId", isEqualTo: user.uid)
            .get();

        kejadianList.value = kejadianQuery.docs
            .map((doc) => Kejadian.fromFireStore(doc.data(), doc.id))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchPenghuni();
    fetchKejadian();
    super.onInit();
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  void deleteKejadian(String docID) {
    try {
      Get.defaultDialog(
          title: "Hapus kejadian",
          middleText: "Apakah anda yakin akan menghapus kejadian ini?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('kejadian')
                .doc(docID)
                .delete();
            Get.back();
            Get.snackbar('Berhasil', 'Kejadian berhasil dihapus');
            Get.offAllNamed(Routes.KEJADIAN);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus kejadian');
    }
  }
}
