import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/KOST.png',
                    width: 74,
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hallo,',
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      Text(
                        'Guido Augusta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.logout();
                    },
                    highlightColor: Colors.transparent,
                    icon:
                        const Icon(Icons.notifications_none_rounded, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appColor.backgroundColor1,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  // childAspectRatio: 0.9,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DashboardMenu(
                      'Penghuni',
                      'assets/images/img_penghuni.png',
                      onTap: () {
                        // Get.toNamed(Routes.RESIDENT);
                      },
                    ),
                    DashboardMenu(
                      'Properti',
                      'assets/images/img_properti.png',
                      onTap: () {
                        Get.toNamed(Routes.PROPERTY);
                      },
                    ),
                    DashboardMenu(
                      'Keuangan',
                      'assets/images/img_keuangan.png',
                      onTap: () {
                        // Get.toNamed(Routes.ADDFINANCE);
                      },
                    ),
                    DashboardMenu(
                      'Kejadian',
                      'assets/images/img_kejadian.png',
                      onTap: () {
                        // Get.toNamed(Routes.EVENT);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Statistik Keuangan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: appColor.buttonTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardMenu extends StatelessWidget {
  final String title;
  final String image;
  final Function()? onTap;

  const DashboardMenu(this.title, this.image, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 84,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
