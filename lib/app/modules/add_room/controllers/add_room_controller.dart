import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRoomController extends GetxController {
  final roomNumberController = TextEditingController();
  final roomSizeController = TextEditingController();
  final roomPriceControllers = <TextEditingController>[TextEditingController()]
      .obs; // List dinamis harga
  final selectedFacilities =
      <String>[].obs; // List untuk fasilitas yang dipilih

  // Daftar fasilitas yang tersedia
  final facilities = [
    "Air",
    "Wi-fi",
    "Lemari",
    "Kasur",
    "Kamar mandi dalam",
    "Mesin cuci",
    "Listrik",
    "Kamar mandi luar"
  ];

  void addFacility(String facility) {
    if (!selectedFacilities.contains(facility)) {
      selectedFacilities.add(facility);
    }
  }

  void removeFacility(String facility) {
    selectedFacilities.remove(facility);
  }

  void addPriceField() {
    roomPriceControllers.add(TextEditingController());
  }

  void removePriceField(int index) {
    if (roomPriceControllers.length > 1) {
      roomPriceControllers.removeAt(index);
    }
  }

  @override
  void onClose() {
    roomNumberController.dispose();
    roomSizeController.dispose();
    for (var controller in roomPriceControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
