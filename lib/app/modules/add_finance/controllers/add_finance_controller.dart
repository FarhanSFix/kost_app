import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_cli/common/utils/json_serialize/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class AddFinanceController extends GetxController {
  var isDendaChecked = true.obs;

  var selectedIndex = Get.arguments;
  RxInt currentIndex = 0.obs;
  var penghuniList = <Penghuni>[].obs;
  var selectedPenghuni = ''.obs;
  var propertiList = <Properti>[].obs;
  var selectedProperti = ''.obs;
  var selectedProperti2 = ''.obs;
  var kamarList = <Kamar>[].obs;
  var selectedKamar = ''.obs;
  var kejadianvalue = Kejadian(
          id: '',
          id_penghuni: '',
          kejadian: '',
          foto_bukti: '',
          nominal: 0,
          status: '')
      .obs;
  var keyHarga = ''.obs;
  var kamarvalue = Kamar(id: '', nomor: '', status: '', harga: {}).obs;
  TextEditingController jmlbulanController = TextEditingController();
  TextEditingController totalMasukController = TextEditingController();
  TextEditingController catatanController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSampaiController = TextEditingController();
  TextEditingController dendaController = TextEditingController();
  TextEditingController uangMukaController = TextEditingController();
  TextEditingController sisaController = TextEditingController();
  var isLoading = false.obs;

  //pengeluaran
  TextEditingController tanggalController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController totalKeluarController = TextEditingController();
  var selectedKategori = ''.obs;
  final kategori = [
    'Pemasaran',
    'Belanja Pokok',
    'Listrik',
    'Air',
    'Gaji Karyawan',
    'Perbaikan',
    'Belanja Perlengkapan',
    'Lainnya'
  ].obs;
  var selectedStatusBayar = 'Lunas'.obs;
  final statusBayar = ['Lunas', 'Belum Lunas'].obs;
  final files = XFile('').obs;
  var jmlPenghuniList = [].obs;
  final selectedJmlPenghuni = ''.obs;

  void fetchPenghuni() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final penghuniQuery = await FirebaseFirestore.instance
          .collection('penghuni')
          .where('userId', isEqualTo: user.uid)
          .get();

      penghuniList.value = penghuniQuery.docs
          .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
          .toList();
    }
  }

  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(tanggal);
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  void fetchProperti() async {
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

  void fetchKamar(String idProperti, String status) async {
    if (idProperti.isNotEmpty) {
      final kamarQuery = await FirebaseFirestore.instance
          .collection('kamar')
          .where('id_properti', isEqualTo: idProperti)
          .where('status', isEqualTo: status)
          .orderBy('nomor')
          .get();

      kamarList.value = kamarQuery.docs
          .map((doc) => Kamar.fromFireStore(doc.data(), doc.id))
          .toList();

      print(idProperti);
      print(kamarList);
    } else {
      kamarList.clear(); // Jika properti kosong, kosongkan daftar kamar
    }
  }

  void fetchHarga(String idK) async {
    try {
      final kamarDoc =
          await FirebaseFirestore.instance.collection('kamar').doc(idK).get();

      if (kamarDoc.exists) {
        kamarvalue.value = Kamar.fromFireStore(kamarDoc.data()!, kamarDoc.id);
        print("kamar nomor: ${kamarvalue.value.nomor}");

        final sortedKeys = kamarvalue.value.harga.keys.toList()
          ..sort((a, b) {
            // Konversi ke int untuk pengurutan
            int jmlA = int.tryParse(a.split(' ').first ?? "0") ?? 0;
            int jmlB = int.tryParse(b.split(' ').first ?? "0") ?? 0;
            return jmlA.compareTo(jmlB);
          });

        // Ubah format menjadi "x orang"
        jmlPenghuniList.value = sortedKeys.map((key) => "$key").toList();

        totalMasukController.text =
            formatNominal(kamarvalue.value.harga[keyHarga]);

        print(jmlPenghuniList);
      } else {
        print("Harga tidak ditemukan dengan ID: $idK");
      }
    } catch (e) {
      print("Gagal mengambil data harga: $e");
    }
  }

  void fetchKejadian(String idPhuni, String status) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('kejadian')
          .where('id_penghuni', isEqualTo: idPhuni)
          .where('status', isEqualTo: status)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Ambil dokumen pertama (sesuai kebutuhan Anda)
        final doc = querySnapshot.docs.first;
        kejadianvalue.value = Kejadian.fromFireStore(doc.data(), doc.id);
        dendaController.text = formatNominal(kejadianvalue.value.nominal);
      } else {
        kejadianvalue.value = Kejadian(
            id: '',
            id_penghuni: '',
            kejadian: '',
            foto_bukti: '',
            nominal: 0,
            status: '');
        dendaController.text = formatNominal(kejadianvalue.value.nominal);
        print(
            "Tidak ada kejadian dengan ID penghuni $idPhuni dan status $status");
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil kejadian: $e');
      print("Error: $e");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      tanggalController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> selectDatePeriode(BuildContext context) async {
    // Memilih tanggal mulai
    final DateTime? pickedDateStart = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDateStart != null) {
      // Parsing jumlah bulan dari jmlbulanController
      int jumlahBulan = int.tryParse(jmlbulanController.text) ?? 0;

      // Menghitung tanggal akhir default berdasarkan jumlah bulan
      DateTime defaultEndDate =
          pickedDateStart.add(Duration(days: 30 * jumlahBulan));

      // Membuka dialog untuk memilih tanggal akhir
      final DateTime? pickedDateEnd = await showDatePicker(
        context: context,
        initialDate: defaultEndDate, // Default date calculated from input
        firstDate:
            pickedDateStart, // Tanggal akhir tidak boleh sebelum tanggal mulai
        lastDate: DateTime(2100),
      );

      // Memperbarui controller jika tanggal akhir dipilih
      if (pickedDateEnd != null) {
        tglMulaiController.text =
            DateFormat('dd/MM/yyyy').format(pickedDateStart);
        tglSampaiController.text =
            DateFormat('dd/MM/yyyy').format(pickedDateEnd);
      }
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

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  @override
  void onInit() {
    if (selectedIndex != null && selectedIndex is int) {
      currentIndex.value = selectedIndex as int;
    }
    fetchPenghuni();
    fetchProperti();
    super.onInit();

    // Listener untuk menghitung sisa dari uang muka
    uangMukaController.addListener(() {
      final totalMasuk =
          int.tryParse(totalMasukController.text.replaceAll(".", "")) ?? 0;
      final uangMuka =
          int.tryParse(uangMukaController.text.replaceAll(".", "")) ?? 0;

      sisaController.text = formatNominal(totalMasuk - uangMuka);
    });

    dendaController.addListener(() {
      final hargaAsli = kamarvalue.value.harga[keyHarga.value] ?? 0;
      final denda = (isDendaChecked.value)
          ? (int.tryParse(dendaController.text.replaceAll(".", "")) ?? 0)
          : 0;

      // Hitung totalMasuk
      totalMasukController.text = formatNominal(hargaAsli + denda);

      // Update sisa jika status belum lunas
      if (selectedStatusBayar.value == 'Belum Lunas') {
        final uangMuka =
            int.tryParse(uangMukaController.text.replaceAll(".", "")) ?? 0;
        sisaController.text = formatNominal((hargaAsli + denda) - uangMuka);
      }
    });

    // Listener untuk checkbox
    isDendaChecked.listen((isChecked) {
      dendaController.text = isChecked ? dendaController.text : "0";
    });
  }

  Future<void> tambahPemasukan(
    String idPenghuni,
    String idPropertiMasuk,
    String idKamar,
    String jmlPenghuni,
    String jmlBulan,
    Map periode,
    int totalMasuk,
    String status,
    int denda,
    int uangMuka,
    int sisa,
    String catatan,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (idPenghuni.isEmpty ||
          idPropertiMasuk.isEmpty ||
          idKamar.isEmpty ||
          jmlPenghuni.isEmpty ||
          jmlBulan.isEmpty ||
          periode.entries.isEmpty ||
          status.isEmpty ||
          denda.isNull ||
          uangMuka.isNull ||
          sisa.isNull ||
          catatan.isEmpty) {
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
          await FirebaseFirestore.instance.collection('pemasukan').add({
            'created_at': DateTime.now(),
            'catatan': catatan,
            'denda': denda,
            'id_kamar': idKamar,
            'id_penghuni': idPenghuni,
            'id_properti': idPropertiMasuk,
            'jml_bulan': jmlBulan,
            'jml_penghuni': jmlPenghuni,
            'periode': periode,
            'sisa': sisa,
            'status': status,
            'total_bayar': totalMasuk,
            'uang_muka': uangMuka,
            'userId': user.uid
          });

          await FirebaseFirestore.instance
              .collection('penghuni')
              .doc(idPenghuni)
              .update({'id_kamar': idKamar, 'id_properti': idPropertiMasuk});

          if (status == 'Belum Lunas') {
            await FirebaseFirestore.instance
                .collection('kamar')
                .doc(idKamar)
                .update({'status': 'Dipesan'});
          } else {
            await FirebaseFirestore.instance
                .collection('kamar')
                .doc(idKamar)
                .update({'status': 'Terisi'});
          }

          final kejadianQuery = await FirebaseFirestore.instance
              .collection('kejadian')
              .where('id_penghuni', isEqualTo: idPenghuni)
              .where('status',
                  isNotEqualTo:
                      'Sudah dibayar') // Pastikan status belum "sudah dibayar"
              .get();

          for (var doc in kejadianQuery.docs) {
            await FirebaseFirestore.instance
                .collection('kejadian')
                .doc(doc.id)
                .update({'status': 'Sudah dibayar'});
          }
          Get.snackbar(
            'Sukses',
            'Pemasukan berhasil ditambahkan!',
          );
          Get.offAllNamed(Routes.FINANCE);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal menambahkan pemasukan: $e',
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat menambahkan pemasukan ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> tambahPengeluaran(
    String idPropertiKeluar,
    File images,
    String judul,
    String kategori,
    DateTime tanggal,
    int totalKeluar,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (images.isNull ||
          judul.isEmpty ||
          idPropertiKeluar.isEmpty ||
          kategori.isEmpty ||
          tanggal.isNull ||
          totalKeluar.isNull) {
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
          await FirebaseFirestore.instance.collection('pengeluaran').add({
            'created_at': DateTime.now(),
            'id_properti': idPropertiKeluar,
            'file': base64String(await images.readAsBytes()),
            'judul': judul,
            'kategori': kategori,
            'tanggal': Timestamp.fromDate(tanggal),
            'total_bayar': totalKeluar,
            'userId': user.uid
          });
          Get.snackbar(
            'Sukses',
            'Pengeluaran berhasil ditambahkan!',
          );
          Get.offAllNamed(Routes.FINANCE);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal menambahkan pengeluaran: $e',
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat menambahkan pengeluaran ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    totalMasukController.dispose();
    tglMulaiController.dispose();
    tglSampaiController.dispose();
    jmlbulanController.dispose();
    dendaController.dispose();
    uangMukaController.dispose();
    sisaController.dispose();
    catatanController.dispose();
    tanggalController.dispose();
    judulController.dispose();
    totalKeluarController.dispose();
    super.onClose();
  }
}
