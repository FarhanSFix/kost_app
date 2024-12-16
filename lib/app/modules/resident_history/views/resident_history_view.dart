import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/resident_history_controller.dart';

class ResidentHistoryView extends GetView<ResidentHistoryController> {
  const ResidentHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Riwayat Penghuni',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.residentList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Tidak ada data',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView.separated(
              itemBuilder: (context, index) {
                var item = controller.residentList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: appColor.backgroundColor2,
                        child: Icon(
                          Icons.person,
                          color: appColor.logoColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nama'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Tanggal Keluar',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              controller
                                  .formatTanggal(item['tgl_checkout'].toDate()),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          final nomor = item['telepon'];
                          // Validasi nomor telepon
                          if (nomor == null || nomor.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Nomor telepon tidak tersedia untuk penghuni ini.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          String formattedNomor = nomor;
                          if (nomor.startsWith('0')) {
                            formattedNomor = '+62${nomor.substring(1)}';
                          }

                          final whatsappUrl = "https://wa.me/$formattedNomor";

                          // Buka WhatsApp
                          launchUrl(Uri.parse(whatsappUrl));

                          print(whatsappUrl);
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 84, 215, 89),
                          child: SvgPicture.asset(
                            'assets/icons/whatsapp.svg',
                            color: Colors.white,
                            width: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: controller.residentList.length,
            ),
          );
        },
      ),
    );
  }
}
