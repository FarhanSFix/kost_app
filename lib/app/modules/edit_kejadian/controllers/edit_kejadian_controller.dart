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

class EditKejadianController extends GetxController {
  final idkejadian = Get.arguments;
  var penghuniList = <Penghuni>[].obs;
  var selectedPenghuni = ''.obs;
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
  TextEditingController kejadianController = TextEditingController();
  TextEditingController nominalController = TextEditingController();

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

  void fetchKejadian(String id) async {
    try {
      final kejadianDoc =
          await FirebaseFirestore.instance.collection('kejadian').doc(id).get();

      if (kejadianDoc.exists) {
        kejadianvalue.value = Kejadian.fromFireStore(
          kejadianDoc.data()!,
          kejadianDoc.id,
        );
        fetchPenghuni();
        fetchPenghuniValue(kejadianvalue.value.id_penghuni);
        kejadianController.text = kejadianvalue.value.kejadian;
        nominalController.text = formatNominal(kejadianvalue.value.nominal);
      } else {
        Get.snackbar("Error", "kejadian tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data kejadian: $e");
    }
  }

  void fetchPenghuniValue(String idPenghuni) async {
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
      image.value = pickedFile;
    }
  }

  @override
  void onInit() {
    fetchKejadian(idkejadian);
    super.onInit();
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  Future<void> updateData(
    String id,
    String idpenghuni,
    String kejadian,
    int nominal,
    String images,
  ) async {
    DocumentReference updateData =
        FirebaseFirestore.instance.collection("kejadian").doc(id);
    final user = FirebaseAuth.instance.currentUser;
    if (idpenghuni.isEmpty ||
        kejadian.isEmpty ||
        nominal.isNaN ||
        images.isNull) {
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
          "foto_bukti": images,
          "id_penghuni": idpenghuni,
          "kejadian": kejadian,
          "nominal": nominal,
          "status": "belum dibayar",
          "userId": user.uid,
        });
        Get.snackbar('Success', 'Data kejadian berhasil diperbarui');
        Get.offAllNamed(Routes.KEJADIAN);
      } catch (e) {
        Get.snackbar('Error', 'Gagal memperbarui data kejadian: $e');
      }
    } else {
      Get.snackbar(
        'Error',
        'Pengguna tidak terautentikasi!',
      );
    }
  }

  Future<void> updateWithImage(
    String id,
    String idpenghuni,
    String kejadian,
    int nominal,
    File images,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (idpenghuni.isEmpty ||
        kejadian.isEmpty ||
        nominal.isNull ||
        images.isNull) {
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
        await FirebaseFirestore.instance.collection('penghuni').doc(id).update({
          'created_at': DateTime.now(),
          'foto_KTP': base64String(await images.readAsBytes()),
          "id_penghuni": idpenghuni,
          "kejadian": kejadian,
          "nominal": nominal,
          "status": "belum dibayar",
          'userId': user.uid
        });
        Get.snackbar(
          'Sukses',
          'Data penghuni berhasil diperbarui!',
        );
        Get.offAllNamed(Routes.PENGHUNI);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui data penghuni: $e',
        );
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
    kejadianController.dispose();
    nominalController.dispose();
    super.onClose();
  }
}
