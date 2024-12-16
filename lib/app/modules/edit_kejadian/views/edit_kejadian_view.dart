import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_kejadian_controller.dart';

class EditKejadianView extends GetView<EditKejadianController> {
  const EditKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Edit Kejadian'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Obx(() {
              final kejadianvalue = controller.kejadianvalue.value;
              final penghunivalue = controller.penghuni.value;
              return Column(
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
                          child: Text('${penghunivalue.nama}'),
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
                  Text("Status",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  TextField(
                    controller: controller.statusController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Status',
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Bukti",
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
                                      child: kejadianvalue.foto_bukti.isNotEmpty
                                          ? Image.memory(
                                              controller.dataFromBase64String(
                                                  kejadianvalue.foto_bukti),
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
                      final selectedPenghuniId =
                          controller.selectedPenghuni.value.isNotEmpty
                              ? controller.selectedPenghuni.value
                              : penghunivalue.id;
                      if (controller.image.value.path.isNotEmpty) {
                        await controller.updateWithImage(
                          kejadianvalue.id,
                          selectedPenghuniId,
                          controller.kejadianController.text,
                          int.parse(controller.nominalController.text
                              .replaceAll('.', '')),
                          File(controller.image.value.path),
                        );
                      } else {
                        await controller.updateData(
                            kejadianvalue.id,
                            selectedPenghuniId,
                            controller.kejadianController.text,
                            int.parse(controller.nominalController.text
                                .replaceAll('.', '')),
                            kejadianvalue.foto_bukti);
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
