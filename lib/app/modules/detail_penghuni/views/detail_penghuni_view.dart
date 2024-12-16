import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/detail_penghuni_controller.dart';

class DetailPenghuniView extends GetView<DetailPenghuniController> {
  const DetailPenghuniView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penghuni'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final penghuni = controller.penghuni.value;
            final properti = controller.properti.value;
            final kamar = controller.kamar.value;
            final pemasukan = controller.pemasukan.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil
                Center(
                  child: ClipOval(
                    child: penghuni.foto_penghuni.isNotEmpty
                        ? Image.memory(
                            base64Decode(penghuni.foto_penghuni),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: appColor.backgroundColor1,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: appColor.logoColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Data Penghuni
                _buildReadOnlyField("Nama Lengkap", penghuni.nama),
                _buildReadOnlyField("No. Telepon", penghuni.telepon),
                _buildReadOnlyField("Properti", properti.nama),
                _buildReadOnlyField("No. Kamar", kamar.nomor),

                const SizedBox(height: 8),

                // Upload Foto
                const Text(
                  "Foto KTP/Kartu Pelajar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: penghuni.foto_KTP.isNotEmpty
                      ? Image(
                          image: MemoryImage(
                            base64Decode(penghuni.foto_KTP),
                          ),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                "Gagal memuat gambar",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                        ),
                ),
                const SizedBox(height: 16),

                // Riwayat Pemasukan
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riwayat Pemasukan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              pemasukan.status == 'Lunas'
                                  ? 'Rp ${controller.formatNominal(pemasukan.totalBayar)}'
                                  : 'Rp ${controller.formatNominal(pemasukan.uangMuka)}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: appColor.income),
                            ),
                            Row(
                              children: [
                                Text(
                                  pemasukan.periode['mulai'] != null
                                      ? controller.formatTanggal(
                                          (pemasukan.periode['mulai']
                                                  as Timestamp)
                                              .toDate(),
                                        )
                                      : '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(' - '),
                                Text(
                                  pemasukan.periode['sampai'] != null
                                      ? controller.formatTanggal(
                                          (pemasukan.periode['sampai']
                                                  as Timestamp)
                                              .toDate(),
                                        )
                                      : '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 35,
                            width: MediaQuery.sizeOf(context).width * 1 / 4.2,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.ADD_FINANCE);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: appColor.buttonColorPrimary,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  'Perpanjang',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(
                            Uri.parse('https://wa.me/${penghuni.telepon}'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.income,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(100, 42),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/whatsapp.svg',
                            color: Colors.white,
                            width: 21,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Hubungi",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.hapusPenghuni(penghuni.id, kamar.id);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 42),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
