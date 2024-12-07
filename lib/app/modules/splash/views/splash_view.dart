import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/KOST.png",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Design by KitKat Team",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}
