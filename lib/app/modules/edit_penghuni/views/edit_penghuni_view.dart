// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_penghuni_controller.dart';

class EditPenghuniView extends GetView<EditPenghuniController> {
  const EditPenghuniView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Penghuni'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Obx(() {
              final penghuni = controller.penghuni.value;
              final propertivalue = controller.properti.value;
              final kamarvalue = controller.kamar.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Obx(() {
                      return Stack(
                        children: [
                          controller.imageprofile.value.path.isNotEmpty
                              ? ClipOval(
                                  child: Image.file(
                                    File(controller.imageprofile.value.path),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipOval(
                                  child: penghuni.foto_penghuni.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(penghuni.foto_penghuni),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              appColor.backgroundColor1,
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                            color: appColor.logoColor,
                                          ),
                                        ),
                                ),
                          Positioned(
                            bottom: -10,
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                final pickedFileProfile =
                                    await controller.getImageProfile(true);
                                if (pickedFileProfile != null) {
                                  controller.imageprofile.value =
                                      pickedFileProfile;
                                }
                              },
                              icon: Icon(
                                Icons.edit_square,
                                size: 25,
                                color: appColor.buttonColorPrimary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
                  Text("Properti",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedProperti.value,
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text('${propertivalue.nama}'),
                        ),
                        ...controller.propertiList.map((properti) {
                          return DropdownMenuItem(
                            value: properti.id,
                            child: Text(properti.nama),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        controller.selectedProperti.value = value ?? '';
                        controller.fetchKamarList(
                            controller.selectedProperti.value, 'Tersedia');
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
                  Text("Kamar",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedKamar.value,
                      items: [
                        DropdownMenuItem(
                          value: '', // Tambahkan nilai default
                          child: Text('Kamar ${kamarvalue.nomor}'),
                        ),
                        ...controller.kamarList.map((kamar) {
                          return DropdownMenuItem(
                            value: kamar.id,
                            child: Text(kamar.nomor), // Tampilkan nomor kamar
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        controller.selectedKamar.value = value ?? '';
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
                  Text("Edit foto KTP/Kartu Pelajar",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  Row(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              controller.image.value.path.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(controller.image.value.path),
                                        height: 150,
                                        width: 300,
                                        fit: BoxFit.cover,
                                      ))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: penghuni.foto_KTP.isNotEmpty
                                          ? Image.memory(
                                              base64Decode(penghuni.foto_KTP),
                                              height: 150,
                                              width: 300,
                                              fit: BoxFit.cover,
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                await controller.getImage(true);
                                              },
                                              child: Container(
                                                height: 150,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  color: appColor.bgcontainer,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                    child: Icon(Icons
                                                        .add_circle_outline_rounded)),
                                              ),
                                            ),
                                    )
                            ],
                          ),
                        ],
                      ),
                      Obx(
                        () => Column(
                          children: [
                            Center(
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
                            IconButton(
                                onPressed: () {
                                  controller.getImage(true);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: appColor.buttonColorPrimary,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.buttonColorPrimary,
                        foregroundColor: Color(0xFFFFFFFF),
                        minimumSize: Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      final selectedpropertiId =
                          controller.selectedProperti.value.isNotEmpty
                              ? controller.selectedProperti.value
                              : propertivalue.id;
                      final selectedKamarId =
                          controller.selectedKamar.value.isNotEmpty
                              ? controller.selectedKamar.value
                              : kamarvalue.id;
                      final imagesProfile =
                          controller.imageprofile.value.path.isNotEmpty
                              ? File(controller.imageprofile.value.path)
                              : penghuni.foto_penghuni;
                      final imagesKTP = controller.image.value.path.isNotEmpty
                          ? File(controller.image.value.path)
                          : penghuni.foto_KTP;
                      if (controller.image.value.path.isNotEmpty ||
                          controller.imageprofile.value.path.isNotEmpty) {
                        await controller.updateWithImage(
                            penghuni.id,
                            controller.nameController.text,
                            controller.telpController.text,
                            selectedpropertiId,
                            selectedKamarId,
                            imagesKTP,
                            imagesProfile);
                      } else {
                        controller.updateData(
                            penghuni.id,
                            controller.nameController.text,
                            controller.telpController.text,
                            selectedpropertiId,
                            selectedKamarId,
                            penghuni.foto_KTP,
                            penghuni.foto_penghuni);
                      }
                    },
                    child: Text("Perbarui",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
