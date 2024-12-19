// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_penghuni_controller.dart';

class AddPenghuniView extends GetView<AddPenghuniController> {
  const AddPenghuniView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('Tambah Penghuni'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.PENGHUNI),
                icon: Icon(Icons.close_rounded))
          ],
        ),
        body: Obx(() {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        controller.imageprofile.value.path != ''
                            ? ClipOval(
                                child: Image.file(
                                  File(controller.imageprofile.value.path),
                                  height:
                                      100, // Sesuaikan ukuran dengan radius CircleAvatar
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: appColor.backgroundColor1,
                                child: Icon(
                                  Icons.person,
                                  size: 46,
                                  color: appColor.logoColor,
                                ),
                              ),
                        Positioned(
                            bottom: -20,
                            right: 10,
                            child: IconButton(
                                onPressed: () {
                                  controller.getImageProfile(true);
                                },
                                icon: Icon(
                                  Icons.edit_square,
                                  size: 25,
                                  color: appColor.buttonColorPrimary,
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Nama Lengkap",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama penghuni',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("No. Telepon",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    controller: controller.telpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nomor telepon',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Text("Properti",
                  //     style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  // Obx(() {
                  //   return DropdownButtonFormField<String>(
                  //     value: controller.selectedProperti.value,
                  //     items: [
                  //       DropdownMenuItem(
                  //         value: '',
                  //         child: Text('Pilih properti'),
                  //       ),
                  //       ...controller.propertiList.map((properti) {
                  //         return DropdownMenuItem(
                  //           value: properti.id,
                  //           child: Text(properti.nama),
                  //         );
                  //       }).toList(),
                  //     ],
                  //     onChanged: (value) {
                  //       controller.selectedProperti.value = value ?? '';
                  //       controller.fetchKamar(
                  //           controller.selectedProperti.value, 'Tersedia');
                  //     },
                  //     decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //   );
                  // }),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  // Text("Kamar", style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  // Obx(() {
                  //   return DropdownButtonFormField<String>(
                  //     value: controller.selectedKamar.value.isEmpty
                  //         ? null // Jika nilai kosong, atur sebagai null
                  //         : controller.selectedKamar.value,
                  //     items: [
                  //       DropdownMenuItem(
                  //         value: '', // Tambahkan nilai default
                  //         child: Text('Pilih kamar'),
                  //       ),
                  //       ...controller.kamarList.map((kamar) {
                  //         return DropdownMenuItem(
                  //           value: kamar.id,
                  //           child: Text(kamar.nomor), // Tampilkan nomor kamar
                  //         );
                  //       }).toList(),
                  //     ],
                  //     onChanged: (value) {
                  //       controller.selectedKamar.value = value ?? '';
                  //     },
                  //     decoration: InputDecoration(
                  //       hintText: 'Pilih kamar',
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //   );
                  // }),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  Text("Unggah foto KTP/Kartu Pelajar",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Row(
                    children: [
                      controller.image.value.path != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(controller.image.value.path),
                                height: 150,
                                width: 300,
                                fit: BoxFit.cover,
                              ))
                          : GestureDetector(
                              onTap: () async {
                                await controller.getImage(true);
                              },
                              child: Container(
                                height: 150,
                                width: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: appColor.bgcontainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child:
                                        Icon(Icons.add_circle_outline_rounded)),
                              ),
                            ),
                      Obx(
                        () => Center(
                          child: controller.image.value.path != ""
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    controller.image.value = XFile("");
                                  },
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.buttonColorPrimary,
                        foregroundColor: Color(0xFFFFFFFF),
                        minimumSize: Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: controller.isLoading.value
                        ? null // Disable tombol jika sedang loading
                        : () async {
                            await controller.saveData(
                                controller.nameController.text,
                                controller.telpController.text,
                                // controller.selectedProperti.value,
                                // controller.selectedKamar.value,
                                '',
                                '',
                                File(controller.image.value.path),
                                File(controller.imageprofile.value.path));
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Simpan",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
