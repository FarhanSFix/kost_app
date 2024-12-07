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
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
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
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF888888)),
                ),
                SizedBox(
                  height: 30,
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
                Obx(
                  () {
                    return TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        hintStyle: TextStyle(
                            color: Color(0xFF03071E).withOpacity(0.25)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          onPressed: () {
                            controller.isPasswordHidden.value =
                                !controller.isPasswordHidden.value;
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.RESET_PASSWORD),
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(color: appColor.buttonTextColor),
                    ),
                  ),
                ),
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
                  child: Text("Masuk",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(Routes.REGISTER),
                        child: Text(
                          "Daftar Sekarang",
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
