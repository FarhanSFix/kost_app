import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isconfirmPasswordHidden = true.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String username, String email, String password,
      String confirmPassword) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'all field shouldn\'t be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "Password and confirmation password do not match.");
      return;
    }

    try {
      QuerySnapshot usernameCheck = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameCheck.docs.isNotEmpty) {
        Get.snackbar("Error", "Username is already taken.");
        return;
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
      await userCredential.user!.sendEmailVerification();
      Get.snackbar("Success", "User registered successfully.");
      Get.defaultDialog(
        title: 'Verify your email',
        middleText:
            'Please verify your email to continue. We have sent you an email verification link.',
        textConfirm: 'OK',
        textCancel: 'Resend',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.offAllNamed(Routes.LOGIN);
        },
        onCancel: () async {
          await userCredential.user!.sendEmailVerification();
          Get.snackbar('Success', 'Email verification link sent');
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Registration failed: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
