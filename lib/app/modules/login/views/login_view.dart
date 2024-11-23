// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: TextStyle(fontFamily: 'Jaro', fontSize: 64),
            ),
            Text(
              "Selamat datang di KOST",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
            ),
            Text(
              "Masuk dan nikmati banyak fitur untuk mengelola kos",
              style: TextStyle(
                  fontFamily: 'Roboto', fontSize: 14, color: Color(0xFF888888)),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Email"),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: 'Masukkan email',
                hintStyle: TextStyle(color: Color(0xFF888888)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text("Password"),
            Obx(() {
              return TextField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  hintStyle: TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              height: 16,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(color: appColor.buttonTextColor),
                  ),
                )),
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
                controller.login(controller.emailController.text,
                    controller.passwordController.text);
              },
              child: Text("Masuk"),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun?"),
                  TextButton(
                      onPressed: () => Get.offNamed(Routes.REGISTER),
                      child: Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: appColor.buttonTextColor,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
