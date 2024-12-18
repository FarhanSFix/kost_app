import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/kejadian_controller.dart';

class KejadianView extends GetView<KejadianController> {
  const KejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.toNamed(Routes.FINANCE),
            icon: Icon(Icons.arrow_back_rounded)),
        title: const Text('Daftar Kejadian'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.searchPenghuni(value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                labelText: "Nama Penghuni",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter kejadian list berdasarkan searchNama
                final filteredKejadian =
                    controller.kejadianList.where((kejadian) {
                  final penghuni = controller.penghuniList.firstWhereOrNull(
                    (p) => p.id == kejadian.id_penghuni,
                  );
                  return penghuni != null &&
                      penghuni.nama
                          .toLowerCase()
                          .contains(controller.searchNama.value);
                }).toList();

                if (filteredKejadian.isEmpty) {
                  return Center(
                    child: Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 1 / 5,
                          ),
                          Image.asset(
                            "assets/images/no_data.jpg",
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Belum Ada Data Kejadian',
                            style:
                                TextStyle(fontFamily: 'Roboto', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredKejadian.length,
                  itemBuilder: (context, index) {
                    final kejadian = filteredKejadian[index];
                    final penghuni = controller.penghuniList.firstWhere(
                      (p) => p.id == kejadian.id_penghuni,
                    );

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_KEJADIAN,
                            arguments: kejadian.id);
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          penghuni.nama,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          kejadian.kejadian,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      kejadian.status,
                                      style: TextStyle(
                                          fontFamily: 'Lato', fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Nominal: Rp ${controller.formatNominal(kejadian.nominal)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.toNamed(Routes.EDIT_KEJADIAN,
                                              arguments: kejadian.id);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          controller
                                              .deleteKejadian(kejadian.id);
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        final nomor = penghuni.telepon;
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
                                          formattedNomor =
                                              '+62${nomor.substring(1)}';
                                        }

                                        final pesan = Uri.encodeComponent(
                                            "Halo *${penghuni.nama}*, terkait kejadian *${kejadian.kejadian}*, mohon dapat dibayar pada saat pembayaran bulanan ya.");
                                        final whatsappUrl =
                                            "https://wa.me/$formattedNomor?text=$pesan";

// Buka WhatsApp
                                        launchUrl(Uri.parse(whatsappUrl));

                                        print(whatsappUrl);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 84, 215, 89),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      icon: SvgPicture.asset(
                                        'assets/icons/whatsapp.svg',
                                        color: Colors.white,
                                        width: 20,
                                      ),
                                      label: const Text(
                                        "Hubungi",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_KEJADIAN);
        },
        backgroundColor: appColor.buttonColorPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(Icons.add),
      ),
    );
  }
}
