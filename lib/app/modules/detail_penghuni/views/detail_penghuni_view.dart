import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/detail_penghuni_controller.dart';

class DetailPenghuniView extends GetView<DetailPenghuniController> {
  const DetailPenghuniView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPenghuniView'),
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
                          children: const [
                            Text(
                              "Riwayat Pemasukan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Rp 600.000"),
                            Text("18/11/2024 - 18/12/2024"),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Logika perpanjangan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor.buttonColorPrimary,
                          ),
                          child: const Text("Perpanjang"),
                        ),
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
                      onPressed: () {},
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
                        controller.hapusPenghuni();
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
