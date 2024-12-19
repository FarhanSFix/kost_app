import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class AddKejadianController extends GetxController {
  var penghuniList = <Penghuni>[].obs;
  var selectedPenghuni = ''.obs;
  final image = XFile("").obs;
  var isLoading = false.obs;

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
    fetchPenghuni();
    super.onInit();
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  Future<void> saveData(
    String idpenghuni,
    String kejadian,
    int nominal,
    File images,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (kejadian.isEmpty || nominal.isNull || images.isNull) {
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
          await FirebaseFirestore.instance.collection('kejadian').add({
            'created_at': DateTime.now(),
            'id_penghuni': idpenghuni,
            'foto_bukti': base64String(await images.readAsBytes()),
            'kejadian': kejadian,
            'nominal': nominal,
            'status': 'Belum dibayar',
            'userId': user.uid
          });
          Get.snackbar(
            'Sukses',
            'Kejadian berhasil ditambahkan!',
          );
          Get.offAllNamed(Routes.KEJADIAN);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal menambahkan kejadian: $e',
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan kejadian: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    kejadianController.dispose();
    nominalController.dispose();
    super.onClose();
  }
}
