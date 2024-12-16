import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class DetailPemasukanController extends GetxController {
  final idPemasukan = Get.arguments;
  var pemasukan = Pemasukan(
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
  var properti = Properti(id: '', nama: '').obs;
  var kamarvalue = Kamar(id: '', nomor: '', status: '', harga: {}).obs;
  var penghunivalue = Penghuni(
          id: '',
          nama: '',
          telepon: '',
          idProperti: '',
          idKamar: '',
          isActive: true,
          foto_KTP: '',
          foto_penghuni: '')
      .obs;
  var selectedStatusBayar = 'Lunas'.obs;

  TextEditingController namaPenghuniController = TextEditingController();
  TextEditingController propertiContoller = TextEditingController();
  TextEditingController kamarController = TextEditingController();
  TextEditingController jmlPenghuniController = TextEditingController();
  TextEditingController jmlBulanController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSampaiController = TextEditingController();
  TextEditingController totalMasukController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController dendaController = TextEditingController();
  TextEditingController tglPelunasanController = TextEditingController();
  TextEditingController uangMukaController = TextEditingController();
  TextEditingController sisaController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

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

        print("ID Properti: ${pemasukan.value.idProperti}");

        // Tunggu hingga fetchProperti selesai
        await fetchPenghuni(pemasukan.value.idPenghuni);
        await fetchProperti(pemasukan.value.idProperti);
        await fetchKamar(pemasukan.value.idKamar);
        selectedStatusBayar.value = pemasukan.value.status;
        namaPenghuniController.text = penghunivalue.value.nama;
        propertiContoller.text = properti.value.nama;
        kamarController.text = 'Kamar ${kamarvalue.value.nomor}';
        jmlPenghuniController.text = pemasukan.value.jmlPenghuni;
        jmlBulanController.text = '${pemasukan.value.jmlBulan} Bulan';
        tglMulaiController.text = formatTanggal(
            (pemasukan.value.periode['mulai'] as Timestamp).toDate());
        tglSampaiController.text = formatTanggal(
            (pemasukan.value.periode['sampai'] as Timestamp).toDate());
        totalMasukController.text = formatNominal(pemasukan.value.totalBayar);
        statusController.text = pemasukan.value.status;
        dendaController.text = formatNominal(pemasukan.value.denda);
        uangMukaController.text = formatNominal(pemasukan.value.uangMuka);
        sisaController.text = formatNominal(pemasukan.value.sisa);
        catatanController.text = pemasukan.value.catatan;
      } else {
        Get.snackbar("Error", "Pengeluaran tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengeluaran: $e");
      print(e);
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
        // propertiController.text = properti.value.nama;
      } else {
        print("Properti tidak ditemukan dengan ID: $idP");
      }
    } catch (e) {
      print("Gagal mengambil data properti: $e");
    }
  }

  Future<void> fetchPenghuni(String idhuni) async {
    try {
      final penghuniDoc = await FirebaseFirestore.instance
          .collection('penghuni')
          .doc(idhuni)
          .get();

      if (penghuniDoc.exists) {
        penghunivalue.value =
            Penghuni.fromFirestore(penghuniDoc.data()!, penghuniDoc.id);
        // propertiController.text = properti.value.nama;
      } else {
        print("penghuni tidak ditemukan dengan ID: $idhuni");
      }
    } catch (e) {
      print("Gagal mengambil data penghuni: $e");
    }
  }

  Future<void> fetchKamar(String idK) async {
    try {
      final kamarDoc =
          await FirebaseFirestore.instance.collection('kamar').doc(idK).get();

      if (kamarDoc.exists) {
        kamarvalue.value = Kamar.fromFireStore(kamarDoc.data()!, kamarDoc.id);
        print("kamar ditemukan: ${kamarvalue.value.nomor}");
        // kamarController.text = kamar.value.nama;
      } else {
        print("kamar tidak ditemukan dengan ID: $idK");
      }
    } catch (e) {
      print("Gagal mengambil data kamar: $e");
    }
  }

  Future<void> fetchData() async {
    await fetchPemasukan(idPemasukan);
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void deletePemasukan(String docID) {
    try {
      Get.defaultDialog(
          title: "Hapus Pemasukan",
          middleText: "Apakah anda yakin akan menghapus pemasukan ini?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('pemasukan')
                .doc(docID)
                .delete();
            Get.back();
            Get.snackbar('Berhasil', 'pemasukan berhasil dihapus');
            Get.offAllNamed(Routes.FINANCE);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pemasukan');
    }
  }

  @override
  void onClose() {
    namaPenghuniController.dispose();
    propertiContoller.dispose();
    kamarController.dispose();
    jmlPenghuniController.dispose();
    jmlBulanController.dispose();
    tglMulaiController.dispose();
    tglSampaiController.dispose();
    totalMasukController.dispose();
    statusController.dispose();
    dendaController.dispose();
    uangMukaController.dispose();
    sisaController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
