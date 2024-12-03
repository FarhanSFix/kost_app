import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/kejadian_controller.dart';

class KejadianView extends GetView<KejadianController> {
  const KejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KejadianView'),
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
                  return const Center(
                      child: Text("Tidak ada kejadian ditemukan"));
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
                                    const SizedBox(height: 20),
                                    Text(
                                      'Nominal: Rp ${kejadian.nominal}',
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
                                          // Logika untuk menghapus kejadian
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Logika untuk menghubungi via WhatsApp
                                      final nomor = penghuni.telepon;
                                      final pesan = Uri.encodeComponent(
                                          "Halo ${penghuni.nama}, terkait kejadian ${kejadian.kejadian}.");
                                      final whatsappUrl =
                                          "https://wa.me/$nomor?text=$pesan";
                                      Get.toNamed(
                                          whatsappUrl); // Atau gunakan launchUrl
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/icons/whatsapp.svg',
                                      color: Colors.white,
                                      width: 20,
                                    ),
                                    label: const Text("Hubungi"),
                                  ),
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