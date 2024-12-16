import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Rx<User?> firebaseUser = Rx<User?>(null);
  var isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
  }

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.emailVerified) {
        Get.snackbar('Sukses', 'Pengguna berhasil masuk');
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar('Error', 'Tolong verifikasi email anda terlebih dahulu');
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'Email atau password salah');
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
            'Error', 'Terlalu banyak percobaan login. Coba lagi nanti');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Terjadi kesalahan. Coba lagi nanti');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
