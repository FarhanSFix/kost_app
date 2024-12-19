import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class DetailPenghuniController extends GetxController {
  final String idpenghuni = Get.arguments;
  final image = XFile("").obs;

  var penghuni = Penghuni(
          id: '',
          nama: '',
          telepon: '',
          foto_KTP: '',
          foto_penghuni: '',
          idProperti: '',
          isActive: true,
          idKamar: '')
      .obs;
  var properti = Properti(id: '', nama: '-').obs;
  var kamar = Kamar(id: '', nomor: '-', status: '', harga: {}).obs;
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
  @override
  void onInit() {
    fetchPenghuni(idpenghuni);
    super.onInit();
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  // Fungsi format tanggal
  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(tanggal);
  }

  void fetchPemasukan(String idPenghuni) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pemasukan')
          .where('id_penghuni', isEqualTo: idPenghuni)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Ambil dokumen pertama (sesuai kebutuhan Anda)
        final doc = querySnapshot.docs.first;
        pemasukan.value = Pemasukan.fromFireStore(doc.data(), doc.id);
      } else {
        pemasukan.value = Pemasukan(
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
            uangMuka: 0);
        print("Tidak ada pemasukan dengan ID pemasukan $idPenghuni");
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil pemasukan: $e');
      print("Error: $e");
    }
  }

  void fetchPenghuni(String id) async {
    try {
      final penghuniDoc =
          await FirebaseFirestore.instance.collection('penghuni').doc(id).get();

      if (penghuniDoc.exists) {
        penghuni.value = Penghuni.fromFirestore(
          penghuniDoc.data()!,
          penghuniDoc.id,
        );

        fetchProperti(penghuni.value.idProperti);
        fetchKamar(penghuni.value.idKamar);
        fetchPemasukan(penghuni.value.id);
      } else {
        Get.snackbar("Error", "Penghuni tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data penghuni: $e");
    }
  }

  void fetchProperti(String idproperti) async {
    try {
      final propertiDoc = await FirebaseFirestore.instance
          .collection('properti')
          .doc(idproperti)
          .get();
      if (propertiDoc.exists) {
        properti.value =
            Properti.fromFireStore(propertiDoc.data()!, propertiDoc.id);
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchKamar(String idkamar) async {
    try {
      final kamarDoc = await FirebaseFirestore.instance
          .collection('kamar')
          .doc(idkamar)
          .get();
      if (kamarDoc.exists) {
        kamar.value = Kamar.fromFireStore(kamarDoc.data()!, kamarDoc.id);
      }
    } catch (e) {
      print(e);
    }
  }

  void hapusPenghuni(String docID, String idKamar) {
    try {
      Get.defaultDialog(
        title: "Hapus penghuni",
        middleText: "Apakah anda yakin akan menghapus penghuni ini?",
        onConfirm: () async {
          try {
            // Validasi idKamar
            if (idKamar.isEmpty || idKamar == '-') {
              Get.back();
              Get.snackbar(
                "Error",
                "Penghuni ini belum masuk ke kamar.",
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }

            // Cek status pembayaran penghuni
            final pemasukanQuery = await FirebaseFirestore.instance
                .collection('pemasukan')
                .where('id_penghuni', isEqualTo: docID)
                .get();

            bool belumLunas = pemasukanQuery.docs.any((doc) {
              final data = doc.data();
              return data['status'] == 'Belum Lunas';
            });

            if (belumLunas) {
              Get.back(); // Tutup dialog
              Get.snackbar(
                'Gagal',
                'Penghuni tidak dapat dihapus karena masih memiliki tagihan yang belum lunas.',
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }

            // Hapus dokumen penghuni
            await FirebaseFirestore.instance
                .collection('penghuni')
                .doc(docID)
                .delete();

            // Hapus dokumen dari koleksi "pemasukan"
            for (var doc in pemasukanQuery.docs) {
              await doc.reference.delete();
            }

            // Hapus dokumen dari koleksi "kejadian"
            final kejadianQuery = await FirebaseFirestore.instance
                .collection('kejadian')
                .where('id_penghuni', isEqualTo: docID)
                .get();
            for (var doc in kejadianQuery.docs) {
              await doc.reference.delete();
            }

            // Update status kamar
            await FirebaseFirestore.instance
                .collection('kamar')
                .doc(idKamar)
                .update({'status': 'Tersedia'});

            Get.back();
            Get.snackbar('Berhasil', 'Penghuni berhasil dihapus.');
            Get.offAllNamed(Routes.PENGHUNI);
          } catch (e) {
            print(e);
            Get.snackbar(
              'Error',
              'Gagal menghapus penghuni dan data terkait.',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        },
        textConfirm: "Ya, saya yakin",
        textCancel: "Tidak",
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Tidak dapat memproses permintaan Anda.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
