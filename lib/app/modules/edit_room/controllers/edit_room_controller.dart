import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditRoomController extends GetxController {
  final Map<String, dynamic> room = Get.arguments;
  final roomNumberController = TextEditingController();
  final wideController = TextEditingController();
  final roomPriceControllers =
      <TextEditingController>[TextEditingController()].obs;
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

  void addPriceField() {
    // Tentukan key baru berdasarkan jumlah harga
    final newKey = "Orang ${roomPrices.length + 1}";
    roomPrices[newKey] = 0; // Tambahkan key baru dengan nilai default
    roomPriceControllers
        .add(TextEditingController(text: "0")); // Controller untuk harga baru
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

  @override
  void onInit() {
    roomNumberController.text = room['nomor'] ?? '';
    selectedStatus.value = room['status'];
    wideController.text = room['luas']?.toString() ?? '';
    facilities.value = List<String>.from(room['fasilitas'] ?? []);

    if (room['harga'] is Map) {
      roomPrices.assignAll(room['harga'] as Map<String, dynamic>);
      roomPrices.forEach((key, value) {
        roomPriceControllers.add(TextEditingController(text: value.toString()));
      });
    } else {
      roomPrices.assignAll({});
    }
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
