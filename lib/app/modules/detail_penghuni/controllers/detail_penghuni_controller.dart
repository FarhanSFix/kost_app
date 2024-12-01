import 'package:flutter/material.dart';

import '../views/detail_penghuni_view.dart';

class DetailPenghuniController extends ChangeNotifier {
  final Penghuni penghuni = Penghuni(
    nama: "Farhan",
    noTelepon: "62876543219",
    properti: "Kos Iqbal",
    noKamar: "Kamar 1",
  );

  void perpanjangSewa() {
    // Logika untuk memperpanjang sewa
    notifyListeners();
  }

  void hapusPenghuni() {
    // Logika untuk menghapus penghuni
    notifyListeners();
  }
}
