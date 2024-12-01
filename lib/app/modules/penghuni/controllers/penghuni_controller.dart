import 'package:flutter/material.dart';

class PenghuniController extends ChangeNotifier {
  // Data pilihan
  final List<String> options = ['Semua', 'Kos Iqbal', 'Kos Farhan'];
  String selectedValue = 'Semua'; // Nilai default
  TextEditingController searchController = TextEditingController();

  // Update nilai yang dipilih
  void updateSelectedValue(String value) {
    selectedValue = value;
    notifyListeners(); // Memberitahu UI untuk melakukan rebuild
  }

  // Fungsi pencarian
  void search(String query) {
    // Implementasi logika pencarian penghuni (misalnya filter list)
    notifyListeners(); // Memberitahu UI untuk melakukan rebuild
  }
}
