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

class EditPenghuniController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  final String idpenghuni = Get.arguments;
  var isLoading = false.obs;
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
  var properti = Properti(id: '', nama: '-').obs;
  var kamar = Kamar(id: '', nomor: '-', status: '', harga: {}).obs;
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

  Future<void> updateData(
    String id,
    String namaPenghuni,
    String noTelp,
    String idProperti,
    String idKamar,
    String images,
    String imageProfiles,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      DocumentReference updateData =
          FirebaseFirestore.instance.collection("penghuni").doc(id);
      final user = FirebaseAuth.instance.currentUser;
      if (namaPenghuni.isEmpty ||
          noTelp.isEmpty ||
          idProperti.isEmpty ||
          idKamar.isEmpty) {
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
            "foto_KTP": images,
            "foto_penghuni": imageProfiles,
            "id_kamar": idKamar,
            "id_properti": idProperti,
            "is_active": true,
            "nama": namaPenghuni,
            "telepon": noTelp,
            "userId": user.uid,
          });
          Get.snackbar('Success', 'Data penghuni berhasil diperbarui');
          Get.offAllNamed(Routes.PENGHUNI);
        } catch (e) {
          Get.snackbar('Error', 'Gagal memperbarui data penghuni: $e');
        }
      } else {
        Get.snackbar(
          'Error',
          'Pengguna tidak terautentikasi!',
        );
      }
    } catch (e) {
      Get.snackbar("Error", " Gagal Memeperbarui data Penghuni ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWithImage(
    String id,
    String namaPenghuni,
    String noTelp,
    String idProperti,
    String idKamar,
    dynamic images,
    dynamic imageProfiles,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (namaPenghuni.isEmpty ||
          noTelp.isEmpty ||
          idProperti.isEmpty ||
          idKamar.isEmpty) {
        Get.snackbar(
          'Error',
          'Semua kolom wajib diisi!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
      String imageKTPBase64 = images is File
          ? base64Encode(await images.readAsBytes())
          : images; // Jika String, gunakan langsung
      String imageProfileBase64 = imageProfiles is File
          ? base64Encode(await imageProfiles.readAsBytes())
          : imageProfiles; // Jika String, gunakan langsung
      if (user != null) {
        if (namaPenghuni.isEmpty ||
            noTelp.isEmpty ||
            idProperti.isEmpty ||
            idKamar.isEmpty) {
          Get.snackbar(
            'Error',
            'Semua kolom wajib diisi!',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }
        try {
          await FirebaseFirestore.instance
              .collection('penghuni')
              .doc(id)
              .update({
            'created_at': DateTime.now(),
            'foto_KTP': imageKTPBase64,
            'foto_penghuni': imageProfileBase64,
            'id_kamar': idKamar,
            'id_properti': idProperti,
            'is_active': true,
            'nama': namaPenghuni,
            'telepon': noTelp,
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
    } catch (e) {
      Get.snackbar("Error", " Gagal Memeperbarui data Penghuni ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    telpController.dispose();
    super.onClose();
  }
}
