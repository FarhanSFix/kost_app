import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class EditPemasukanController extends GetxController {
  final idMasuk = Get.arguments;
  var isDendaChecked = true.obs;

  TextEditingController jmlBulanController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSampaiController = TextEditingController();
  TextEditingController totalMasukController = TextEditingController();
  TextEditingController dendaController = TextEditingController();
  TextEditingController uangMukaController = TextEditingController();
  TextEditingController sisaController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

  final pemasukan = Pemasukan(
    catatan: '',
    denda: 0,
    dibuat: DateTime.timestamp(),
    id: '',
    idKamar: '',
    idPenghuni: '',
    idProperti: '',
    jmlBulan: '',
    jmlPenghuni: '',
    periode: {},
    sisa: 0,
    status: '',
    totalBayar: 0,
    uangMuka: 0,
  ).obs;
  var penghuniList = <Penghuni>[].obs;
  final selectedPenghuni = ''.obs;
  var propertiList = <Properti>[].obs;
  final selectedProperti = ''.obs;
  var kamarList = <Kamar>[].obs;
  final selectedKamar = ''.obs;
  var jmlPenghuniList = [].obs;
  final selectedJmlPenghuni = ''.obs;
  var kamarvalue = Kamar(harga: {}, id: '', nomor: '', status: '').obs;
  final statusPembayaran = ['Lunas', 'Belum Lunas'].obs;
  var selectedStatusBayar = 'Lunas'.obs;

  var keyHarga = ''.obs;

  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(tanggal);
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  Future<void> fetchPemasukan(String id) async {
    try {
      final pemasukanDoc = await FirebaseFirestore.instance
          .collection('pemasukan')
          .doc(id)
          .get();

      if (pemasukanDoc.exists) {
        pemasukan.value = Pemasukan.fromFireStore(
          pemasukanDoc.data()!,
          pemasukanDoc.id,
        );

        selectedPenghuni.value = pemasukan.value.idPenghuni;
        selectedProperti.value = pemasukan.value.idProperti;
        print("ID Properti: ${pemasukan.value.idProperti}");
        await fetchList();
        await fetchKamarList(pemasukan.value.idProperti);
        selectedKamar.value = pemasukan.value.idKamar;
        await fetchHarga(pemasukan.value.idKamar);
        selectedJmlPenghuni.value = pemasukan.value.jmlPenghuni;

        selectedStatusBayar.value = pemasukan.value.status;
        jmlBulanController.text = '${pemasukan.value.jmlBulan} Bulan';
        tglMulaiController.text = formatTanggal(
            (pemasukan.value.periode['mulai'] as Timestamp).toDate());
        tglSampaiController.text = formatTanggal(
            (pemasukan.value.periode['sampai'] as Timestamp).toDate());
        totalMasukController.text = formatNominal(pemasukan.value.totalBayar);
        dendaController.text = formatNominal(pemasukan.value.denda);
        uangMukaController.text = formatNominal(pemasukan.value.uangMuka);
        sisaController.text = formatNominal(pemasukan.value.sisa);
        catatanController.text = pemasukan.value.catatan;
      } else {
        Get.snackbar("Error", "Pemasukan tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pemasukan: $e");
    }
  }

  Future<void> fetchPenghuniList() async {
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

  Future<void> fetchPropertiList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final properti = await FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .get();

      propertiList.value = properti.docs
          .map((docs) => Properti.fromFireStore(docs.data(), docs.id))
          .toList();
    }
  }

  Future<void> fetchKamarList(String propertiId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final kamar = await FirebaseFirestore.instance
          .collection('kamar')
          .where('userId', isEqualTo: user.uid)
          .where('id_properti', isEqualTo: propertiId)
          .get();

      kamarList.value = kamar.docs
          .map((docs) => Kamar.fromFireStore(docs.data(), docs.id))
          .toList();
    }
  }

  Future<void> fetchHarga(String idK) async {
    try {
      final kamarDoc =
          await FirebaseFirestore.instance.collection('kamar').doc(idK).get();

      if (kamarDoc.exists) {
        kamarvalue.value = Kamar.fromFireStore(kamarDoc.data()!, kamarDoc.id);
        print("kamar nomor: ${kamarvalue.value.nomor}");
        jmlPenghuniList.value = kamarvalue.value.harga.keys.toList();

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

  @override
  void onInit() {
    super.onInit();
    fetchData();
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

  Future<void> fetchData() async {
    await fetchPemasukan(idMasuk);
  }

  Future<void> fetchList() async {
    await fetchPenghuniList();
    await fetchPropertiList();
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
      int jumlahBulan = int.tryParse(jmlBulanController.text) ?? 0;

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

  Future<void> updateData(
    String id,
    String catatan,
    int denda,
    String idKamar,
    String idPenghuni,
    String idProperti,
    String jmlBulan,
    String jmlPenghuni,
    Map periode,
    int sisa,
    String status,
    int totalBayar,
    int uangMuka,
  ) async {
    DocumentReference updateData =
        FirebaseFirestore.instance.collection("pemasukan").doc(id);
    final user = FirebaseAuth.instance.currentUser;
    if (catatan.isEmpty ||
        denda.isNull ||
        idKamar.isEmpty ||
        idPenghuni.isEmpty ||
        idProperti.isEmpty ||
        jmlBulan.isEmpty ||
        jmlPenghuni.isEmpty ||
        periode.isEmpty ||
        sisa.isNull ||
        status.isEmpty ||
        totalBayar.isNull ||
        uangMuka.isNull) {
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
          'catatan': catatan,
          'denda': denda,
          'id_kamar': idKamar,
          'id_penghuni': idPenghuni,
          'id_properti': idProperti,
          'jml_bulan': jmlBulan,
          'jml_penghuni': jmlPenghuni,
          'periode': periode,
          'sisa': sisa,
          'status': status,
          'total_bayar': totalBayar,
          'uang_muka': uangMuka,
          'userId': user.uid
        });
        Get.snackbar('Success', 'Data pemasukan berhasil diperbarui');
        Get.offAllNamed(Routes.FINANCE);
      } catch (e) {
        Get.snackbar('Error', 'Gagal memperbarui data pemasukan: $e');
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
    penghuniList.clear();
    propertiList.clear();
    kamarList.clear();
    jmlBulanController.dispose();
    tglMulaiController.dispose();
    tglSampaiController.dispose();
    totalMasukController.dispose();
    dendaController.dispose();
    uangMukaController.dispose();
    sisaController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
