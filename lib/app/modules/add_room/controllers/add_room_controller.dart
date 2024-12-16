import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class AddRoomController extends GetxController {
  final String propertyId = Get.arguments ?? "defaultPropertyId";
  final roomNumberController = TextEditingController();
  final wideController = TextEditingController();
  final roomPriceControllers =
      <TextEditingController>[TextEditingController()].obs;
  final RxList<String> Facilities = [
    'Air',
    'Wi-fi',
    'Lemari',
    'Kasur',
    'Kamar mandi dalam',
    'Mesin cuci',
    'Listrik',
    'Kamar mandi luar'
  ].obs;
  void removeFacility(int index) {
    Facilities.removeAt(index);
  }

  void addFacility(String facility) {
    Facilities.add(facility);
  }

  final statusOptions = ["Tersedia", "Terisi", "Dipesan", "Diperbaiki"];

  final selectedStatus = "Tersedia".obs;

  final RxMap<String, int> hargaMap = <String, int>{}.obs;

  void addPrice(String jumlahOrang, int harga) {
    hargaMap["${jumlahOrang} orang"] = harga;
  }

  void updatePrice(String jumlahOrang, int harga) {
    if (hargaMap.containsKey(jumlahOrang)) {
      hargaMap["${jumlahOrang} orang"] = harga;
    }
  }

  void removePrice(String jumlahOrang) {
    hargaMap.remove(jumlahOrang);
  }

  void addRoom({
    required String nomorKamar,
    required String status,
    required List fasilitas,
    required int luas,
    required Map<String, int> harga,
    required String idproperti,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (nomorKamar.isEmpty ||
        status.isEmpty ||
        fasilitas.isEmpty ||
        luas <= 0 ||
        harga.isEmpty) {
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
        await FirebaseFirestore.instance.collection('kamar').add({
          'created_at': DateTime.now(),
          'nomor': nomorKamar,
          'status': status,
          'fasilitas': fasilitas,
          'luas': luas.toInt(),
          'harga': harga,
          'userId': user.uid,
          'id_properti': idproperti
        });

        Get.snackbar(
          'Sukses',
          'Kamar berhasil ditambahkan!',
        );
        Get.offAllNamed(Routes.ROOM, arguments: propertyId);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menambahkan kamar: $e',
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Pengguna tidak terautentikasi!',
      );
    }
  }

  @override
  void onClose() {
    roomNumberController.dispose();
    wideController.dispose();
    for (var controller in roomPriceControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
