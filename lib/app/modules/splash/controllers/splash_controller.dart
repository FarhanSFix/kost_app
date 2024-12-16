import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(Duration(seconds: 1));
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offNamed(Routes.MAIN);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
