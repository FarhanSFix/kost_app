// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/detail_pengeluaran_controller.dart';

class DetailPengeluaranView extends GetView<DetailPengeluaranController> {
  const DetailPengeluaranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.toNamed(Routes.FINANCE),
              icon: Icon(Icons.arrow_back_rounded)),
          title: const Text('Detail Pengeluaran'),
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
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
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
                      TextField(
                        controller: controller.propertiController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
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
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                      TextField(
                        controller: controller.kategoriController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
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
                        "File",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: controller.pengeluaran.value.file.isNotEmpty
                            ? Image(
                                image: MemoryImage(
                                  controller.dataFromBase64String(
                                      controller.pengeluaran.value.file),
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
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.EDIT_PENGELUARAN,
                                  arguments: controller.pengeluaran.value.id);
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller
                                  .deletePengeluaran(controller.idPengeluaran);
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ]),
              );
            }
          },
        ));
  }
}
