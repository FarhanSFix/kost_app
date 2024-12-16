import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class EditRoomController extends GetxController {
  final String idRoom = Get.arguments;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getRoom(String docID) async {
    DocumentReference docRef = firestore.collection('kamar').doc(docID);
    return docRef.get();
  }

  // final Map<String, dynamic> room = Get.arguments;
  final roomNumberController = TextEditingController();
  final wideController = TextEditingController();
  final roomPriceControllers = <TextEditingController>[].obs;
  var facilities = <String>[].obs;
  final roomPrices = <String, dynamic>{}.obs;
  void removeFacility(int index) {
    facilities.removeAt(index);
  }

  void addFacility(String facility) {
    facilities.add(facility);
  }

  final statusOptions = ["Tersedia", "Terisi", "Dipesan", "Diperbaiki"];
  final selectedStatus = ''.obs;

  final RxMap<String, int> hargaMap = <String, int>{}.obs;

  void addPrice(String jumlahOrang, int harga) {
    final key = "${jumlahOrang} orang";
    hargaMap[key] = harga;
    roomPrices[key] = harga;
    roomPriceControllers.add(TextEditingController(text: harga.toString()));
  }

  void updatePrice(String jumlahOrang, int harga) {
    final key = "${jumlahOrang} orang";

    if (hargaMap.containsKey(key)) {
      // Update harga di maps
      hargaMap[key] = harga;
      roomPrices[key] = harga;

      // Update controller sesuai key
      final index = roomPrices.keys.toList().indexOf(key);
      if (index >= 0 && index < roomPriceControllers.length) {
        roomPriceControllers[index].text = harga.toString();
      }
    }
  }

  void removePriceField(int index) {
    if (roomPriceControllers.length > 1) {
      // Hapus dari roomPrices berdasarkan index
      final keyToRemove = roomPrices.keys.elementAt(index);
      roomPrices.remove(keyToRemove);

      // Hapus controller terkait
      roomPriceControllers[index].dispose();
      roomPriceControllers.removeAt(index);
    }
  }

  void updateRoom({
    required String docId,
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
        luas.isNull ||
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
        await FirebaseFirestore.instance.collection('kamar').doc(docId).update({
          'created_at': DateTime.now(),
          'nomor': nomorKamar,
          'status': status,
          'fasilitas': fasilitas,
          'luas': luas,
          'harga': harga,
          'userId': user.uid,
          'id_properti': idproperti
        });

        Get.snackbar(
          'Sukses',
          'Kamar berhasil diperbarui!',
        );
        Get.offAllNamed(Routes.DETAIL_ROOM, arguments: idRoom);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui kamar: $e',
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
  void onInit() {
    super.onInit();
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
