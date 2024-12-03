import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  var properti = Properti(id: '', nama: '').obs;
  var kamar = Kamar(id: '', nomor: '', status: '').obs;
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

  void hapusPenghuni() async {
    try {
      // Konfirmasi penghapusan
      bool? konfirmasi = await Get.defaultDialog<bool>(
        title: "Konfirmasi",
        middleText: "Apakah Anda yakin ingin menghapus penghuni ini?",
        textConfirm: "Ya",
        textCancel: "Tidak",
        onConfirm: () {
          Get.back(result: true);
        },
        onCancel: () {
          Get.back(result: false);
        },
      );

      if (konfirmasi == true) {
        // Hapus penghuni dari Firestore
        await FirebaseFirestore.instance
            .collection('penghuni')
            .doc(idpenghuni)
            .delete();

        Get.snackbar("Berhasil", "Penghuni berhasil dihapus.");
        Get.toNamed(Routes.PENGHUNI);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus penghuni: $e");
    }
  }
}
