import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/data/model.dart';

class EditPenghuniController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  final String idpenghuni = Get.arguments;
  var propertiList = <Properti>[].obs;
  var selectedProperti = ''.obs;
  var kamarList = <Kamar>[].obs;
  var selectedKamar = ''.obs;
  final image = XFile("").obs;
  final imageprofile = XFile("").obs;

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

  void fetchPropertiList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final propertiQuery = await FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .get();

      propertiList.value = propertiQuery.docs
          .map((doc) => Properti.fromFireStore(doc.data(), doc.id))
          .toList();
      fetchProperti(penghuni.value.idProperti);
      fetchKamar(penghuni.value.idKamar);
    }
  }

  void fetchKamarList(String idProperti, String status) async {
    if (idProperti.isNotEmpty) {
      final kamarQuery = await FirebaseFirestore.instance
          .collection('kamar')
          .where('id_properti', isEqualTo: idProperti)
          .where('status', isEqualTo: status) // Ambil kamar yang tersedia
          .get();

      kamarList.value = kamarQuery.docs
          .map((doc) => Kamar.fromFireStore(doc.data(), doc.id))
          .toList();
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
      imageprofile.value = pickedFile;
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

        fetchPropertiList();
        fetchProperti(penghuni.value.idProperti);
        fetchKamar(penghuni.value.idKamar);
        print(kamar.value.nomor);
        nameController.text = penghuni.value.nama;
        telpController.text = penghuni.value.telepon;
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
}
