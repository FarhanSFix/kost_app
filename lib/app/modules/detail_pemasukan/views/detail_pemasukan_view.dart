import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/detail_pemasukan_controller.dart';

class DetailPemasukanView extends GetView<DetailPemasukanController> {
  const DetailPemasukanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Pemasukan'),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
            future: controller.fetchPemasukan(controller.idPemasukan),
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
                        "Detail sewa",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: controller.namaPenghuniController,
                        readOnly: true,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.propertiContoller,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.kamarController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: controller.jmlPenghuniController,
                        readOnly: true,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Detail Tenggat Waktu",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.sizeOf(context).width * 1 / 3,
                        child: TextField(
                          controller: controller.jmlBulanController,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Jumlah bulan',
                              hintStyle:
                                  TextStyle(fontFamily: 'Lato', fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.tglMulaiController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.tglSampaiController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rp'),
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            controller.totalMasukController,
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            hintText: '0',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            border: InputBorder.none),
                                      ),
                                    )
                                  ],
                                ),
                                height: 40,
                                width: MediaQuery.sizeOf(context).width * 1 / 3,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 4, right: 8, bottom: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: appColor.backgroundColor3),
                                child: Row(
                                  // Add Row or Column as the parent
                                  children: [
                                    Expanded(
                                      // Expanded now works correctly inside Row
                                      child: TextField(
                                        controller: controller.statusController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                            hintText: 'status',
                                            contentPadding: EdgeInsets.only(
                                                right: 8, bottom: 10),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                                height: 40,
                                width: MediaQuery.sizeOf(context).width * 1 / 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Denda",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rp'),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.dendaController,
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            hintText: '0',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            border: InputBorder.none),
                                      ),
                                    )
                                  ],
                                ),
                                height: 40,
                                width: MediaQuery.sizeOf(context).width * 1 / 3,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Obx(() {
                        if (controller.selectedStatusBayar.value ==
                            'Belum Lunas') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Uang Muka",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Rp'),
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                controller.uangMukaController,
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                hintText: '0',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                border: InputBorder.none),
                                          ),
                                        )
                                      ],
                                    ),
                                    height: 40,
                                    width: MediaQuery.sizeOf(context).width *
                                        1 /
                                        3,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sisa",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Rp'),
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                controller.sisaController,
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                hintText: '0',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                border: InputBorder.none),
                                          ),
                                        )
                                      ],
                                    ),
                                    height: 40,
                                    width: MediaQuery.sizeOf(context).width *
                                        1 /
                                        3,
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return SizedBox(); // Kosongkan jika status lunas
                        }
                      }),
                      //catatan
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            "Catatan",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "(Opsional)",
                            style:
                                TextStyle(fontFamily: 'Roboto', fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: controller.catatanController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Catatan',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(
                            Icons.delete,
                            color: appColor.outcome,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.EDIT_PEMASUKAN,
                                  arguments: controller.pemasukan.value.id);
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
                              controller.deletePemasukan(
                                  controller.penghunivalue.value.id);
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
                    ],
                  ),
                );
              }
            }));
  }
}
