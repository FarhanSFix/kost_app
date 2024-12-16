import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentStatusController extends GetxController {
  var isExpanded = ExpansionTileController();

  var belumBayar =
      <String>[].obs; // Observable list untuk penghuni yang belum bayar
  var belumLunas =
      <String>[].obs; // Observable list untuk penghuni yang belum lunas
  var lunas = <String>[].obs; // Observable list untuk penghuni yang sudah lunas

  var totalPenghuni = 0.obs;
  var statusPembayaran = ''.obs; // Lunas, belum_bayar, belum_lunas, kosong
  var totalBelumBayar = 0.obs;
  var totalBelumLunas = 0.obs;
  var totalLunas = 0.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getJumlahStatusPembayaranBulanIni();
  }

  DateTime getAwalBulanIni() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1); // Hari pertama bulan ini
  }

  DateTime getAkhirBulanIni() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 1)
        .subtract(const Duration(days: 1)); // Hari terakhir bulan ini
  }

  void getJumlahStatusPembayaranBulanIni() {
    final firestore = FirebaseFirestore.instance;
    final awalBulan = getAwalBulanIni();
    final akhirBulan = getAkhirBulanIni();

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore
        .collection('penghuni')
        .where('userId', isEqualTo: userId)
        .where('is_active', isEqualTo: true)
        .where('id_kamar', isNotEqualTo: "")
        .where('id_kamar', isNotEqualTo: null)
        .snapshots()
        .listen((penghuniSnapshot) async {
      totalPenghuni.value = penghuniSnapshot.docs.length;
      print('Total Penghuni: ${totalPenghuni.value}');

      // Reset variabel sebelum menghitung ulang
      totalBelumBayar.value = 0;
      totalBelumLunas.value = 0;
      totalLunas.value = 0;
      belumBayar.clear();
      belumLunas.clear();
      lunas.clear();

      for (var penghuniDoc in penghuniSnapshot.docs) {
        final idPenghuni = penghuniDoc.id;
        final namaPenghuni = penghuniDoc['nama']; // Ambil nama penghuni

        firestore
            .collection('pemasukan')
            .where('id_penghuni', isEqualTo: idPenghuni)
            .where('periode.mulai', isLessThanOrEqualTo: akhirBulan)
            .where('periode.sampai', isGreaterThanOrEqualTo: awalBulan)
            .snapshots()
            .listen((pemasukanSnapshot) {
          if (pemasukanSnapshot.docs.isEmpty) {
            totalBelumBayar.value++;
            belumBayar.add(namaPenghuni); // Tambahkan ke list "Belum Bayar"
          } else {
            bool sudahLunas =
                pemasukanSnapshot.docs.any((doc) => doc['status'] == 'Lunas');

            if (sudahLunas) {
              totalLunas.value++;
              lunas.add(namaPenghuni); // Tambahkan ke list "Lunas"
            } else {
              totalBelumLunas.value++;
              belumLunas.add(namaPenghuni); // Tambahkan ke list "Belum Lunas"
            }
          }

          print(
              'Realtime Update: Belum Bayar: ${belumBayar.length}, Belum Lunas: ${belumLunas.length}, Lunas: ${lunas.length}');
        });
      }
    });
  }
}
