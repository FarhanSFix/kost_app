import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class FinanceController extends GetxController {
  RxInt currentIndex = 0.obs;
  var pemasukanList = <Pemasukan>[].obs;
  var pengeluaranList = <Pengeluaran>[].obs;
  final selectedBulan = "Semua".obs;
  final selectedBulan2 = "Semua".obs;
  final selectedTahun = "Semua".obs;
  final selectedTahun2 = "Semua".obs;
  var isLoading = true.obs;
  final bulanList = [
    "Semua",
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ].obs;
  var tahunList = [
    "Semua",
  ].obs;
  var tahunList2 = [
    "Semua",
  ].obs;
  var pemasukanvalue = Pemasukan(
          id: '',
          catatan: '',
          dibuat: DateTime.timestamp(),
          denda: 0,
          idKamar: '',
          idPenghuni: '',
          idProperti: '',
          jmlBulan: '',
          jmlPenghuni: '',
          sisa: 0,
          status: '',
          periode: {},
          totalBayar: 0,
          uangMuka: 0)
      .obs;
  var penghuniList = <Penghuni>[].obs;
  var propertiList = <Properti>[].obs;
  var kamarList = <Kamar>[].obs;

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  // Fungsi format tanggal
  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(tanggal);
  }

  void fetchPemasukan() async {
    fetchPenghuni();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pemasukanQuery = await FirebaseFirestore.instance
          .collection('pemasukan')
          .where("userId", isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .get();

      var allPemasukan = pemasukanQuery.docs
          .map((doc) => Pemasukan.fromFireStore(doc.data(), doc.id))
          .toList();

      // Filter data berdasarkan bulan dan tahun
      if (selectedBulan.value != "Semua" || selectedTahun.value != "Semua") {
        allPemasukan = allPemasukan.where((pemasukan) {
          final date = pemasukan.dibuat; // Asumsikan `dibuat` adalah DateTime
          final bulan = selectedBulan.value != "Semua"
              ? bulanList.indexOf(selectedBulan.value)
              : null;
          final tahun = selectedTahun.value != "Semua"
              ? int.parse(selectedTahun.value)
              : null;

          return (bulan == null || date.month == bulan) &&
              (tahun == null || date.year == tahun);
        }).toList();
      }

      pemasukanList.value = allPemasukan;
      print("Filtered Pemasukan: ${pemasukanList.length}");
    }
  }

  void fetchPengluaran() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pengeluaranQuery = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .where("userId", isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .get();

      var allPengeluaran = pengeluaranQuery.docs
          .map((doc) => Pengeluaran.fromFireStore(doc.data(), doc.id))
          .toList();

      // Filter data berdasarkan bulan dan tahun
      if (selectedBulan.value != "Semua" || selectedTahun.value != "Semua") {
        allPengeluaran = allPengeluaran.where((pengeluaran) {
          final date = pengeluaran.dibuat; // Asumsikan `dibuat` adalah DateTime
          final bulan = selectedBulan.value != "Semua"
              ? bulanList.indexOf(selectedBulan.value)
              : null;
          final tahun = selectedTahun.value != "Semua"
              ? int.parse(selectedTahun.value)
              : null;

          return (bulan == null || date.month == bulan) &&
              (tahun == null || date.year == tahun);
        }).toList();
      }

      pengeluaranList.value = allPengeluaran;
      print("Filtered Pemasukan: ${pemasukanList.length}");
    }
  }

  void fetchTahunList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pemasukanQuery = await FirebaseFirestore.instance
          .collection('pemasukan')
          .where("userId", isEqualTo: user.uid)
          .get();

      // Ekstrak daftar tahun dari data
      final tahunSet = pemasukanQuery.docs
          .map((doc) => Pemasukan.fromFireStore(doc.data(), doc.id).dibuat.year)
          .toSet();

      tahunList.addAll(tahunSet.map((tahun) => tahun.toString()).toList());
    }
  }

  void fetchTahunPengeluaran() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pengeluaranQuery = await FirebaseFirestore.instance
          .collection('pengeluaran')
          .where("userId", isEqualTo: user.uid)
          .get();

      final tahunSet2 = pengeluaranQuery.docs
          .map((doc) =>
              Pengeluaran.fromFireStore(doc.data(), doc.id).dibuat.year)
          .toSet();
      tahunList2.addAll(tahunSet2.map((tahun) => tahun.toString()).toList());
    }
  }

  void fetchPenghuni() async {
    isLoading.value = true; // Mulai loading
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final penghuniQuery = await FirebaseFirestore.instance
          .collection('penghuni')
          .where('userId', isEqualTo: user.uid)
          .get();

      penghuniList.value = penghuniQuery.docs
          .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
          .toList();

      print("Penghuni: ${penghuniList.length}"); // Debug log
    }
    isLoading.value = false; // Loading selesai
  }

  void fetchProperti() async {
    isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final propertiQuery = await FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .get();

      propertiList.value = propertiQuery.docs
          .map((doc) => Properti.fromFireStore(doc.data(), doc.id))
          .toList();

      print("Penghuni: ${propertiList.length}"); // Debug log
    }
    isLoading.value = false;
  }

  void fetchKamar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final kamarQuery = await FirebaseFirestore.instance
          .collection('kamar')
          .where('userId', isEqualTo: user.uid)
          .get();

      kamarList.value = kamarQuery.docs
          .map((doc) => Kamar.fromFireStore(doc.data(), doc.id))
          .toList();

      print("Penghuni: ${kamarList.length}"); // Debug log
    }
  }

  @override
  void onInit() {
    fetchPenghuni();
    fetchProperti();
    fetchKamar();
    fetchPemasukan();
    fetchPengluaran();
    fetchTahunList();
    fetchTahunPengeluaran();
    update();
    super.onInit();
  }

  void deletePemasukan(String docId, String idKamar) async {
    try {
      await FirebaseFirestore.instance
          .collection('pemasukan')
          .doc(docId)
          .delete();

      await FirebaseFirestore.instance
          .collection('kamar')
          .doc(idKamar)
          .update({'status': 'Tersedia'});
      Get.toNamed(Routes.FINANCE);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pemasukan');
    }
  }

  void lunasi(String docId, String namaPenghuni) async {
    try {
      Get.defaultDialog(
          title: "Konfirmasi Pelunasan",
          middleText:
              "Apakah penghuni ${namaPenghuni} telah melakukan pelunasan?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('pemasukan')
                .doc(docId)
                .update({'status': 'Lunas', 'uang_muka': 0, 'sisa': 0});
            Get.back();
            Get.snackbar('Berhasil', '${namaPenghuni} sudah Lunas');
            Get.offAllNamed(Routes.FINANCE);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat melakukan pelunasan');
    }
  }

  void deletePengeluaran(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengeluaran')
          .doc(docID)
          .delete();
      Get.toNamed(Routes.FINANCE);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pengeluaran');
    }
  }

  @override
  void onReady() {
    update();
    super.onReady();
  }
}
