import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_pengeluaran_controller.dart';

class EditPengeluaranView extends GetView<EditPengeluaranController> {
  const EditPengeluaranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.toNamed(Routes.FINANCE),
              icon: Icon(Icons.arrow_back_rounded)),
          title: const Text('Edit Pengeluaran'),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
          future: controller.fetchPengeluaran(controller.idPengeluaran),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return Obx(() {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        controller: controller.tanggalController,
                        readOnly: true,
                        onTap: () => controller.selectDate(context),
                        decoration: InputDecoration(
                          hintText: 'Pilih Tanggal',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Properti",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: controller.selectedProperti.value,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('Pilih properti'),
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
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Judul Pengeluaran",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        controller: controller.judulController,
                        decoration: InputDecoration(
                          hintText: 'Cth. Bayar Air',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Kategori Pengeluaran",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: controller.selectedKategori.value.isEmpty
                              ? null
                              : controller.selectedKategori.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedKategori.value = value;
                            }
                          },
                          items: controller.kategoriList
                              .map((kategori) => DropdownMenuItem(
                                    value: kategori,
                                    child: Text(kategori),
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            hintText: 'Kategori Pengeluaran',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Total",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColor.backgroundColor3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rp'),
                            Expanded(
                              child: TextField(
                                controller: controller.totalKeluarController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    hintText: '0',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                        height: 40,
                        width: MediaQuery.sizeOf(context).width * 1 / 3,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Upload File",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  controller.files.value.path.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(controller.files.value.path),
                                            height: 150,
                                            width: 300,
                                            fit: BoxFit.cover,
                                          ))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: controller.pengeluaran.value
                                                  .file.isNotEmpty
                                              ? Image.memory(
                                                  controller
                                                      .dataFromBase64String(
                                                          controller.pengeluaran
                                                              .value.file),
                                                  height: 150,
                                                  width: 300,
                                                  fit: BoxFit.cover,
                                                )
                                              : GestureDetector(
                                                  onTap: () async {
                                                    await controller
                                                        .getImage(true);
                                                  },
                                                  child: Container(
                                                    height: 150,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color:
                                                          appColor.bgcontainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                  child: controller.files.value.path != ""
                                      ? IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            controller.files.value = XFile("");
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
                            minimumSize: Size(double.infinity, 42),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          final selectedPropertiId =
                              controller.selectedProperti.value.isNotEmpty
                                  ? controller.selectedProperti.value
                                  : controller.pengeluaran.value.idproperti;
                          if (controller.files.value.path.isNotEmpty) {
                            await controller.updateWithImage(
                                controller.pengeluaran.value.id,
                                DateFormat('dd-MM-yyyy')
                                    .parse(controller.tanggalController.text),
                                selectedPropertiId,
                                controller.judulController.text,
                                controller.selectedKategori.value,
                                int.parse(controller.totalKeluarController.text
                                    .replaceAll(".", "")),
                                File(controller.files.value.path));
                          } else {
                            await controller.updateData(
                                controller.pengeluaran.value.id,
                                DateFormat('dd-MM-yyyy')
                                    .parse(controller.tanggalController.text),
                                selectedPropertiId,
                                controller.judulController.text,
                                controller.selectedKategori.value,
                                int.parse(controller.totalKeluarController.text
                                    .replaceAll(".", "")),
                                controller.pengeluaran.value.file);
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
                  ),
                );
              }); // Widget untuk menampilkan detail
            }
          },
        ));
  }
}
