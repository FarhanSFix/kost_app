// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/detail_room_controller.dart';

class DetailRoomView extends GetView<DetailRoomController> {
  const DetailRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail Kamar "),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.offAllNamed(Routes.PROPERTY),
                icon: Icon(Icons.close_rounded))
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getRoom(controller.idRoom),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Properti tidak ditemukan.'));
            }

            final dataRoom = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: appColor.backgroundColor1,
                      child: Icon(
                        Icons.bed,
                        size: 46,
                        color: appColor.logoColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Nomor Kamar",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: dataRoom['nomor']),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Status Kamar",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: dataRoom['status']),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Fasilitas",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        dataRoom['fasilitas'].length ?? '',
                        (index) => GestureDetector(
                            onTap: () {},
                            child: Chip(
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(color: Colors.black)),
                              label: Text(
                                dataRoom['fasilitas'][index],
                                style: const TextStyle(color: Colors.black),
                              ),
                            )),
                      )),
                  Text("Luas Kamar (m2)",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: dataRoom['luas'].toString()),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Harga/bulan",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Column(
                    children: List.generate(
                      dataRoom['harga']?.length ?? 0,
                      (index) {
                        final priceMap = dataRoom['harga'];
                        if (priceMap == null || priceMap.isEmpty) {
                          return Text("Harga tidak tersedia");
                        }
                        final person = priceMap.keys.elementAt(index);
                        final price = priceMap[person];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$person",
                              style:
                                  TextStyle(fontFamily: 'Lato', fontSize: 16),
                            ),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                  text:
                                      "Rp ${controller.formatNominal(price).toString()}"),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFF888888)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.EDIT_ROOM,
                              arguments: controller.idRoom);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(94, 42),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.deleteRoom(controller.idRoom);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(94, 42),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
