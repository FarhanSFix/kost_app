import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/modules/history/views/history_view.dart';
import 'package:kost_app/app/modules/home/views/home_view.dart';
import 'package:kost_app/app/modules/profile/views/profile_view.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    Widget body() {
      switch (controller.currentIndex.value) {
        case 0:
          return const HomeView();
        case 1:
          return const HistoryView();
        case 2:
          return const ProfileView();
        default:
          return const HomeView();
      }
    }

    return Scaffold(
      body: Obx(
        () => body(),
      ),
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: appColor.buttonColorPrimary,
            selectedFontSize: 12,
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.currentIndex.value = index,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  color: Colors.grey,
                  width: 21,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  color: appColor.buttonColorPrimary,
                  width: 21,
                ),
                label: 'Beranda',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  Icons.history,
                  color: appColor.buttonColorPrimary,
                ),
                label: 'Riwayat',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, color: Colors.grey),
                activeIcon: Icon(
                  Icons.person_outline,
                  color: appColor.buttonColorPrimary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
