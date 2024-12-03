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

class AddPenghuniController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  final image = XFile("").obs;
  final imageprofile = XFile("").obs;

  var propertiList = <Properti>[].obs;
  var selectedProperti = ''.obs;
  var kamarList = <Kamar>[].obs;
  var selectedKamar = ''.obs;
  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  @override
  void onInit() {
    fetchProperti();
    super.onInit();
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
          .where('status', isEqualTo: status) // Ambil kamar yang tersedia
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

  Future getImageProfile(bool gallery) async {
    //deklarasikan picker
    ImagePicker picker = ImagePicker();
    XFile? pickedFileProfile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFileProfile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFileProfile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }
    //jika user memilih sebuah gambar maka pickedfile di assign kedalam image variable
    if (pickedFileProfile != null) {
      imageprofile.value = pickedFileProfile;
    }
  }

  Future<void> saveData(
    String namaPenghuni,
    String noTelp,
    String idProperti,
    String idKamar,
    File images,
    File imageProfiles,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (namaPenghuni.isEmpty ||
        noTelp.isEmpty ||
        idProperti.isEmpty ||
        idKamar.isEmpty ||
        images.isNull ||
        imageProfiles.isNull) {
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
        await firestore.collection('penghuni').add({
          'created_at': DateTime.now(),
          'foto_KTP': base64String(await images.readAsBytes()),
          'foto_penghuni': base64String(await imageProfiles.readAsBytes()),
          'id_kamar': idKamar,
          'id_properti': idProperti,
          'is_active': true,
          'nama': namaPenghuni,
          'telepon': noTelp,
          'userId': user.uid
        });
        Get.snackbar(
          'Sukses',
          'Penghuni berhasil ditambahkan!',
        );
        Get.offAllNamed(Routes.PENGHUNI);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menambahkan penghuni: $e',
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
    nameController.dispose();
    telpController.dispose();
    super.onClose();
  }
}
