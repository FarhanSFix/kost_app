import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.offNamed(Routes.LOGIN),
            icon: Icon(
              Icons.arrow_back_rounded,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Password",
              style: TextStyle(fontFamily: 'Jaro', fontSize: 40),
            ),
            Text(
              "Masukkan email untuk reset password",
              style: TextStyle(
                  fontFamily: 'Roboto', fontSize: 14, color: Color(0xFF888888)),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Email",
              style: TextStyle(fontFamily: 'Lato', fontSize: 16),
            ),
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
                controller.resetPassword(controller.emailController.text);
              },
              child: Text("Reset Password",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
