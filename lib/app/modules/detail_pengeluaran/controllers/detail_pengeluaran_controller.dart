import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class DetailPengeluaranController extends GetxController {
  final String idPengeluaran = Get.arguments;
  TextEditingController tanggalController = TextEditingController();
  TextEditingController propertiController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController totalKeluarController = TextEditingController();
  final files = XFile("").obs;
  var pengeluaran = Pengeluaran(
          id: '',
          dibuat: DateTime.timestamp(),
          file: '',
          idproperti: '',
          judul: '',
          kategori: '',
          tanggal: DateTime.timestamp(),
          totalBayar: 0)
      .obs;

  var properti = Properti(id: '', nama: '').obs;
  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(tanggal);
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  Future<void> fetchPengeluaran(String id) async {
    try {
      final pengeluaranDoc = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .doc(id)
          .get();

      if (pengeluaranDoc.exists) {
        pengeluaran.value = Pengeluaran.fromFireStore(
          pengeluaranDoc.data()!,
          pengeluaranDoc.id,
        );

        print("ID Properti: ${pengeluaran.value.idproperti}");

        // Tunggu hingga fetchProperti selesai
        await fetchProperti(pengeluaran.value.idproperti);

        // Update nilai controller setelah data selesai diambil
        judulController.text = pengeluaran.value.judul;
        kategoriController.text = pengeluaran.value.kategori;
        totalKeluarController.text =
            formatNominal(pengeluaran.value.totalBayar);
        tanggalController.text = formatTanggal(pengeluaran.value.tanggal);
      } else {
        Get.snackbar("Error", "Pengeluaran tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengeluaran: $e");
    }
  }

  Future<void> fetchProperti(String idP) async {
    try {
      final propertiDoc = await FirebaseFirestore.instance
          .collection('properti')
          .doc(idP)
          .get();

      if (propertiDoc.exists) {
        properti.value =
            Properti.fromFireStore(propertiDoc.data()!, propertiDoc.id);
        print("Properti ditemukan: ${properti.value.nama}");
        propertiController.text = properti.value.nama;
      } else {
        print("Properti tidak ditemukan dengan ID: $idP");
      }
    } catch (e) {
      print("Gagal mengambil data properti: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    tanggalController.text = formatTanggal(pengeluaran.value.tanggal);
  }

  Future<void> fetchData() async {
    await fetchPengeluaran(idPengeluaran);
  }

  void deletePengeluaran(String docID) {
    try {
      Get.defaultDialog(
          title: "Hapus Pengeluaran",
          middleText: "Apakah anda yakin akan menghapus pengeluaran ini?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('pengeluaran')
                .doc(docID)
                .delete();
            Get.back();
            Get.snackbar('Berhasil', 'pengeluaran berhasil dihapus');
            Get.offAllNamed(Routes.FINANCE);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pengeluaran');
    }
  }

  @override
  void onClose() {
    tanggalController.dispose();
    propertiController.dispose();
    judulController.dispose();
    kategoriController.dispose();
    totalKeluarController.dispose();
    super.onClose();
  }
}
