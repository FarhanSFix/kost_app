import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class EditPengeluaranController extends GetxController {
  final idPengeluaran = Get.arguments;
  var propertiList = <Properti>[].obs;
  var selectedProperti = ''.obs;

  TextEditingController tanggalController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController totalKeluarController = TextEditingController();
  var selectedKategori = ''.obs;
  final kategoriList = [
    'Pemasaran',
    'Belanja Pokok',
    'Listrik',
    'Air',
    'Gaji Karyawan',
    'Perbaikan',
    'Belanja Perlengkapan',
    'Lainnya'
  ].obs;
  final files = XFile('').obs;
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
  var isLoading = false.obs;

  var properti = Properti(id: '', nama: '').obs;
  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(tanggal);
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: pengeluaran.value.tanggal,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      tanggalController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  void fetchPropertiList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final propertiQuery = await FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .get();

      propertiList.value = propertiQuery.docs
          .map((doc) => Properti.fromFireStore(doc.data(), doc.id))
          .toList();
    }
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
        selectedProperti.value = pengeluaran.value.idproperti;
        selectedKategori.value = pengeluaran.value.kategori;
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
      } else {
        print("Properti tidak ditemukan dengan ID: $idP");
      }
    } catch (e) {
      print("Gagal mengambil data properti: $e");
    }
  }

  Future getImage(bool gallery) async {
    //deklarasikan picker
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }
    //jika user memilih sebuah gambar maka pickedfile di assign kedalam image variable
    if (pickedFile != null) {
      files.value = pickedFile;
    }
  }

  @override
  void onInit() {
    fetchPropertiList();
    super.onInit();
    fetchData();
    tanggalController.text = formatTanggal(pengeluaran.value.tanggal);
  }

  Future<void> fetchData() async {
    await fetchPengeluaran(idPengeluaran);
  }

  Future<void> updateData(
    String id,
    DateTime tanggal,
    String idProperti,
    String judul,
    String kategori,
    int totalKeluar,
    String files,
  ) async {
    if (isLoading.value) return; // Jika masih loading, abaikan aksi baru
    isLoading.value = true;

    try {
      DocumentReference updateData =
          FirebaseFirestore.instance.collection("pengeluaran").doc(id);
      final user = FirebaseAuth.instance.currentUser;
      if (tanggal.isNull ||
          idProperti.isEmpty ||
          judul.isEmpty ||
          kategori.isEmpty ||
          totalKeluar.isNull ||
          files.isEmpty) {
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
          await updateData.update({
            'tanggal': Timestamp.fromDate(tanggal),
            'id_properti': idProperti,
            'judul': judul,
            'kategori': kategori,
            'total_bayar': totalKeluar,
            'files': files,
            "userId": user.uid,
          });
          Get.snackbar('Success', 'Data pengeluaran berhasil diperbarui');
          Get.offAllNamed(Routes.FINANCE);
        } catch (e) {
          Get.snackbar('Error', 'Gagal memperbarui data pengeluaran: $e');
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui data pengeluaran: $e');
    } finally {
      isLoading.value = false; // Pastikan loading di-reset
    }
  }

  Future<void> updateWithImage(
    String id,
    DateTime tanggal,
    String idProperti,
    String judul,
    String kategori,
    int totalKeluar,
    File files,
  ) async {
    if (isLoading.value) return; // Jika masih loading, abaikan aksi baru
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (tanggal.isNull ||
          idProperti.isEmpty ||
          judul.isEmpty ||
          kategori.isEmpty ||
          totalKeluar.isNull ||
          files.isNull) {
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
          await FirebaseFirestore.instance
              .collection('pengeluaran')
              .doc(id)
              .update({
            'tanggal': Timestamp.fromDate(tanggal),
            'id_properti': idProperti,
            'judul': judul,
            'kategori': kategori,
            'total_bayar': totalKeluar,
            'file': base64String(await files.readAsBytes()),
            "userId": user.uid,
          });
          Get.snackbar(
            'Sukses',
            'Data pengeluaran berhasil diperbarui!',
          );
          Get.offAllNamed(Routes.FINANCE);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal memperbarui data pengeluaran: $e',
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan penghuni: $e');
    } finally {
      isLoading.value = false; // Pastikan loading di-reset
    }
  }
}
