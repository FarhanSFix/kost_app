import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class PenghuniController extends GetxController {
  var propertiList = <Properti>[].obs;
  var penghuniList = <Penghuni>[].obs;
  var pemasukanList = <Pemasukan>[].obs;
  var kamarMap = <String, Kamar>{}.obs;
  var isLoading = true.obs;

  var selectedProperti = 'Semua'.obs;
  var searchNama = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperti();
    fetchKamar();
    fetchPenghuni();
    super.onInit();
  }

  void fetchProperti() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        isLoading.value = true;
        final propertiQuery = await FirebaseFirestore.instance
            .collection('properti')
            .where('userId', isEqualTo: user.uid)
            .get();

        propertiList.value = propertiQuery.docs
            .map((doc) => Properti.fromFireStore(doc.data(), doc.id))
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchPenghuni() async {
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final penghuniQuery = await FirebaseFirestore.instance
            .collection('penghuni')
            .where('id_properti',
                isEqualTo: selectedProperti.value == 'Semua'
                    ? null
                    : selectedProperti.value)
            .where('is_active', isEqualTo: true)
            .where("userId", isEqualTo: user.uid)
            .orderBy('created_at', descending: true)
            .get();

        penghuniList.value = penghuniQuery.docs
            .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
            .toList();
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchKamar() async {
    final kamarQuery =
        await FirebaseFirestore.instance.collection('kamar').get();

    kamarMap.value = {
      for (var doc in kamarQuery.docs)
        doc.id: Kamar.fromFireStore(doc.data(), doc.id)
    };
  }

  void searchPenghuni(String keyword) {
    searchNama.value = keyword.toLowerCase();
    update();
  }

  String getNomorKamar(String idKamar) {
    return kamarMap[idKamar]?.nomor ?? '-';
  }

  String getNamaProperti(String idProperti) {
    final properti = propertiList.firstWhereOrNull(
      (item) => item.id == idProperti,
    );
    return properti?.nama ?? '-';
  }

  void checkOut(String docID, String? idKamar) async {
    if (idKamar == '' || idKamar == '-') {
      Get.snackbar(
        'Error',
        'Penghuni ini belum Masuk',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    try {
      final belumLunasQuery = await FirebaseFirestore.instance
          .collection('pemasukan')
          .where('id_penghuni', isEqualTo: docID)
          .where('status', isEqualTo: 'Belum Lunas')
          .get();

      if (belumLunasQuery.docs.isNotEmpty) {
        Get.snackbar(
          'Gagal Checkout',
          'Penghuni ini masih memiliki pembayaran yang belum lunas.',
        );
        return;
      }

      Get.defaultDialog(
        title: "Checkout",
        middleText:
            "Apakah anda yakin akan melakukan checkout pada penghuni ini?",
        onConfirm: () async {
          await FirebaseFirestore.instance
              .collection('penghuni')
              .doc(docID)
              .update({'is_active': false, 'tgl_checkout': DateTime.now()});

          await FirebaseFirestore.instance
              .collection('kamar')
              .doc(idKamar)
              .update({'status': 'Tersedia'});

          Get.back();
          Get.snackbar('Berhasil', 'Penghuni telah keluar dari kost');
          Get.offAllNamed(Routes.PENGHUNI);
        },
        textConfirm: "Ya, saya yakin",
        textCancel: "Tidak",
      );
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat melakukan checkout');
    }
  }
}
