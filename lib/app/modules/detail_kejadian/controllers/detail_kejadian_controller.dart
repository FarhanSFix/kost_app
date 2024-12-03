import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class DetailKejadianController extends GetxController {
  final String idkejadian = Get.arguments;
  final image = XFile("").obs;
  var kejadianvalue = Kejadian(
          id: '',
          id_penghuni: '',
          kejadian: '',
          foto_bukti: '',
          nominal: 0,
          status: '')
      .obs;

  var penghuni = Penghuni(
          id: '',
          nama: '',
          telepon: '',
          idProperti: '',
          idKamar: '',
          isActive: true,
          foto_KTP: '',
          foto_penghuni: '')
      .obs;

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  void fetchKejadian(String id) async {
    try {
      final kejadianDoc =
          await FirebaseFirestore.instance.collection('kejadian').doc(id).get();

      if (kejadianDoc.exists) {
        kejadianvalue.value = Kejadian.fromFireStore(
          kejadianDoc.data()!,
          kejadianDoc.id,
        );
        fetchPenghuni(kejadianvalue.value.id_penghuni);
      } else {
        Get.snackbar("Error", "kejadian tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data kejadian: $e");
    }
  }

  @override
  void onInit() {
    fetchKejadian(idkejadian);
    super.onInit();
  }

  void fetchPenghuni(String idPenghuni) async {
    try {
      final penghuniDoc = await FirebaseFirestore.instance
          .collection('penghuni')
          .doc(idPenghuni)
          .get();
      if (penghuniDoc.exists) {
        penghuni.value =
            Penghuni.fromFirestore(penghuniDoc.data()!, penghuniDoc.id);
      }
    } catch (e) {
      print(e);
    }
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  void deleteKejadian(String docID) {
    try {
      Get.defaultDialog(
          title: "Hapus kejadian",
          middleText: "Apakah anda yakin akan menghapus kejadian ini?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('kejadian')
                .doc(docID)
                .delete();
            Get.back();
            Get.snackbar('Berhasil', 'Kejadian berhasil dihapus');
            Get.offAllNamed(Routes.KEJADIAN);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus kejadian');
    }
  }
}
