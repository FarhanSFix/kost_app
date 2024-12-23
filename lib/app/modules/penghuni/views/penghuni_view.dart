// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/penghuni_controller.dart';

class PenghuniView extends GetView<PenghuniController> {
  const PenghuniView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.offAllNamed(Routes.MAIN),
            icon: Icon(Icons.arrow_back_rounded)),
        title: const Text('Daftar Penghuni'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedProperti.value,
                items: [
                  DropdownMenuItem(
                    value: 'Semua',
                    child: Text('Semua'),
                  ),
                  ...controller.propertiList.map((properti) {
                    return DropdownMenuItem(
                      value: properti.id,
                      child: Text(properti.nama),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  controller.selectedProperti.value = value ?? 'Semua';
                  controller.fetchPenghuni();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            }),
            SizedBox(
              height: 8,
            ),
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.penghuniList.isEmpty) {
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
                            'Belum Ada Data Penghuni',
                            style:
                                TextStyle(fontFamily: 'Roboto', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                }

                final filteredList = controller.penghuniList.where((penghuni) {
                  return penghuni.nama
                      .toLowerCase()
                      .contains(controller.searchNama.value);
                }).toList();
                if (controller.penghuniList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (filteredList.isEmpty) {
                  return Center(
                    child: Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 1 / 5,
                          ),
                          Image.asset(
                            "assets/images/not_found.jpg",
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Tidak ada penghuni yang sesuai pencarian',
                            style:
                                TextStyle(fontFamily: 'Roboto', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final penghuni = filteredList[index];
                    final nomorKamar =
                        controller.getNomorKamar(penghuni.idKamar);
                    final namaProperti =
                        controller.getNamaProperti(penghuni.idProperti);
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PENGHUNI,
                            arguments: penghuni.id);
                      },
                      child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                penghuni.foto_penghuni.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundImage: MemoryImage(
                                          base64Decode(penghuni.foto_penghuni),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            appColor.backgroundColor1,
                                        child: Icon(
                                          Icons.person,
                                          color: appColor.logoColor,
                                        ),
                                      ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        penghuni.nama,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${namaProperti ?? '-'} \nKamar: ${nomorKamar}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            controller.checkOut(
                                                penghuni.id, penghuni.idKamar);
                                          },
                                          icon: Icon(Icons.logout,
                                              color: Colors.red),
                                          label: Text('Check-out',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 10)),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Get.toNamed(Routes.EDIT_PENGHUNI,
                                                arguments: penghuni.id);
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.grey),
                                          iconSize: 20,
                                        ),
                                      ],
                                    ),
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

                                        final whatsappUrl =
                                            "https://wa.me/$formattedNomor";

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
                                        width: 21,
                                      ),
                                      label: Text('Hubungi',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
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
          Get.toNamed(Routes.ADD_PENGHUNI);
        },
        backgroundColor: appColor.buttonColorPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(Icons.add),
      ),
    );
  }
}
