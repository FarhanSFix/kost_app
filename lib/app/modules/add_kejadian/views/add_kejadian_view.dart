import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_kejadian_controller.dart';

class AddKejadianView extends GetView<AddKejadianController> {
  const AddKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddKejadianView'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Penghuni",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.selectedPenghuni.value,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('Pilih penghuni'),
                    ),
                    ...controller.penghuniList.map((penghuni) {
                      return DropdownMenuItem(
                        value: penghuni.id,
                        child: Text(penghuni.nama),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    controller.selectedPenghuni.value = value ?? '';
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
              Text("Kejadian",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              TextField(
                controller: controller.kejadianController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kejadian',
                  hintStyle: TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text("Nominal",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              TextField(
                controller: controller.nominalController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nomial kejadian',
                  hintStyle: TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text("Bukti", style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              Obx(() {
                return Row(
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
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  controller.image.value = XFile("");
                                },
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ],
                );
              }),
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
                onPressed: () async {
                  await controller.saveData(
                      controller.selectedPenghuni.value,
                      controller.kejadianController.text,
                      int.parse(controller.nominalController.text),
                      File(controller.image.value.path));
                },
                child: Text("Simpan",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ));
  }
}
