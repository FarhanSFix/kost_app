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
  var selectedPhoto = File('').obs; // Tambahkan observable untuk foto
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
      selectedPhoto.value = File(pickedFile.path);
    }
  }

  void updateUserProfile({
    required String username,
    required String phone,
    File? profilePhoto, // Tambahkan parameter untuk foto
  }) async {
    try {
      String? userId = auth.currentUser?.uid;

      if (userId == null) {
        Get.snackbar('Error', 'User tidak ditemukan');
        return;
      }

      // Konversi foto ke Base64 jika ada
      String? photoBase64;
      if (profilePhoto != null) {
        List<int> imageBytes = await profilePhoto.readAsBytes();
        photoBase64 = base64Encode(imageBytes);
      }

      // Data yang akan diperbarui
      Map<String, dynamic> updatedData = {
        'username': username,
        'telepon': phone,
      };

      // Tambahkan data foto jika ada
      if (photoBase64 != null) {
        updatedData['foto'] = photoBase64;
      }

      // Update Firestore
      await firestore.collection('users').doc(userId).update(updatedData);

      Get.snackbar('Sukses', 'Profil berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    }
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
