import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  // Observable untuk data user
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userPhoto = ''.obs;
  var totalProperti = 0.obs;
  var totalPenghuni = 0.obs;
  var selectedPhoto = XFile('').obs; // Tambahkan observable untuk foto
  var usernameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;

  var isLoading = true.obs; // Tambahkan loading state

  // Referensi Firestore dan FirebaseAuth
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    listenToUserData();
    listenToCounts();
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  // Fungsi untuk mengambil data user secara real-time
  void listenToUserData() {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore.collection('users').doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        userName.value = data?['username'] ?? 'Nama Tidak Ditemukan';
        userEmail.value = data?['email'] ?? 'Email Tidak Ditemukan';
        userPhone.value = data?['telepon'] ?? 'Nomor Telepon Belum Diatur';
        userPhoto.value = data?['foto'] ?? '';
        usernameController.value.text = data?['username'] ?? '';
        phoneController.value.text = data?['telepon'] ?? '';
      }
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data user: $e');
    });
  }

  // Fungsi untuk menghitung jumlah properti dan kamar secara real-time
  void listenToCounts() {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    // Listener untuk properti
    firestore
        .collection('properti')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      totalProperti.value = snapshot.docs.length;
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data properti: $e');
    });

    // Listener untuk kamar
    firestore
        .collection('penghuni')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      totalPenghuni.value = snapshot.docs.length;
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data penghuni: $e');
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedPhoto.value = XFile(pickedFile.path);
    }
  }

  Future<void> updateProfileWithPhoto() async {
    if (selectedPhoto.value.path.isEmpty) {
      Get.snackbar('Error', 'Foto belum dipilih');
      return;
    }

    File imageFile = File(selectedPhoto.value.path);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore.collection('users').doc(userId).update({
      'foto': base64Image,
      'username': usernameController.value.text,
      'telepon': phoneController.value.text,
    }).then((value) {
      Get.snackbar('Sukses', 'Profil berhasil diubah');
      userPhoto.value = base64Image;
    }).catchError((e) {
      Get.snackbar('Error', 'Gagal mengubah profil: $e');
    });
  }

  Future<void> updateProfile() async {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore.collection('users').doc(userId).update({
      'username': usernameController.value.text,
      'telepon': phoneController.value.text,
    }).then((value) {
      Get.snackbar('Sukses', 'Profil berhasil diubah');
    }).catchError((e) {
      Get.snackbar('Error', 'Gagal mengubah profil: $e');
    });
  }

  // Fungsi untuk logout
  void logout() async {
    try {
      await auth.signOut();
      Get.snackbar('Logout', 'Anda telah keluar');
      Get.offAllNamed(Routes.LOGIN); // Navigasi ke halaman login
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }
}
