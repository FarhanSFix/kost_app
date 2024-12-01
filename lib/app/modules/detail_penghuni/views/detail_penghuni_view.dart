import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../controllers/detail_penghuni_controller.dart';

class DetailPenghuniView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DetailPenghuniController>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                Get.back(result: 'value');
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Ubah warna sesuai keinginan
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color.fromARGB(255, 211, 236, 255),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Nama Lengkap",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(controller.penghuni.nama),
                SizedBox(height: 10),
                Text("No. Telepon",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(controller.penghuni.noTelepon),
                SizedBox(height: 10),
                Text("Properti", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(controller.penghuni.properti),
                SizedBox(height: 10),
                Text("No. Kamar",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(controller.penghuni.noKamar),
                SizedBox(height: 10),
                const Text(
                  "Bukti foto KTP/Kartu Pelajar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Riwayat Pemasukan",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Rp 600.000",
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '18/11/2024-18/12/2024',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Logika untuk menghubungi
                        },
                        label: Text(
                          "Perpanjang",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 204, 52)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Logika untuk menghubungi
                      },
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Hubungi",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.hapusPenghuni();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Hapus Penghuni",
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class Penghuni {
  final String nama;
  final String noTelepon;
  final String properti;
  final String noKamar;

  Penghuni({
    required this.nama,
    required this.noTelepon,
    required this.properti,
    required this.noKamar,
  });
}
