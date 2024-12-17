// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Text(
                  "Daftar",
                  style: TextStyle(fontFamily: 'Jaro', fontSize: 64),
                ),
                Text(
                  "Selamat datang di KOST",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
                Text(
                  "Buat akun dan kelola kos anda dengan mudah",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF888888)),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Nama Lengkap",
                    style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    hintStyle:
                        TextStyle(color: Color(0xFF03071E).withOpacity(0.25)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Email",
                    style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email',
                    hintStyle:
                        TextStyle(color: Color(0xFF03071E).withOpacity(0.25)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Password",
                    style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                Obx(() {
                  return TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      hintStyle:
                          TextStyle(color: Color(0xFF03071E).withOpacity(0.25)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 8,
                ),
                Text("Konfirmasi Password",
                    style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                Obx(() {
                  return TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isconfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Masukkan ulang password',
                      hintStyle:
                          TextStyle(color: Color(0xFF03071E).withOpacity(0.25)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isconfirmPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        onPressed: () {
                          controller.isconfirmPasswordHidden.value =
                              !controller.isconfirmPasswordHidden.value;
                        },
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.buttonColorPrimary,
                      foregroundColor: Color(0xFFFFFFFF),
                      minimumSize: Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    controller.registerUser(
                        controller.usernameController.text,
                        controller.emailController.text,
                        controller.passwordController.text,
                        controller.confirmPasswordController.text);
                  },
                  child: Text(
                    "Buat Akun",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun? "),
                      InkWell(
                        onTap: () {
                          Get.offNamed(Routes.LOGIN);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: appColor.buttonTextColor,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
