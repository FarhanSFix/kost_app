import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResetPasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ResetPasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
