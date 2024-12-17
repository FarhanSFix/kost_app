// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_pemasukan_controller.dart';

class EditPemasukanView extends GetView<EditPemasukanController> {
  const EditPemasukanView({super.key});
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
          title: const Text('Edit Pemasukan'),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
            future: controller.fetchPemasukan(controller.idMasuk),
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
                        "Detail Sewa",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Obx(() {
                        // Ensure selectedPenghuni.value is valid
                        final validPenghuniIds =
                            controller.penghuniList.map((p) => p.id).toList();
                        if (!validPenghuniIds
                            .contains(controller.selectedPenghuni.value)) {
                          controller.selectedPenghuni.value = '';
                        }

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
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              // Ensure selectedPenghuni.value is valid
                              final validPropertiIds = controller.propertiList
                                  .map((p) => p.id)
                                  .toList();
                              if (!validPropertiIds.contains(
                                  controller.selectedProperti.value)) {
                                controller.selectedProperti.value = '';
                              }

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
                                  controller.selectedProperti.value =
                                      value ?? '';
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
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Obx(() {
                              // Ensure selectedPenghuni.value is valid
                              final validKamarIds = controller.kamarList
                                  .map((p) => p.id)
                                  .toList();
                              if (!validKamarIds
                                  .contains(controller.selectedKamar.value)) {
                                controller.selectedKamar.value = '';
                              }

                              return DropdownButtonFormField<String>(
                                value: controller.selectedKamar.value,
                                items: [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('Pilih kamar'),
                                  ),
                                  ...controller.kamarList.map((kamar) {
                                    return DropdownMenuItem(
                                      value: kamar.id,
                                      child: Text("Kamar ${kamar.nomor}"),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  controller.selectedKamar.value = value ?? '';
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: controller.selectedJmlPenghuni.value.isEmpty
                              ? null // Jika nilai kosong, atur sebagai null
                              : controller.selectedJmlPenghuni.value,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('Jumlah penghuni'),
                            ),
                            ...controller.jmlPenghuniList.map((jmlpenghuni) {
                              return DropdownMenuItem(
                                value: jmlpenghuni.toString(),
                                child: Text(jmlpenghuni),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            controller.selectedJmlPenghuni.value = value ?? '';
                            controller.totalMasukController.text = '';
                            controller.keyHarga.value =
                                controller.selectedJmlPenghuni.value;

                            int harga = controller.kamarvalue.value
                                    .harga[controller.keyHarga.value] ??
                                0;
                            controller.totalMasukController.text =
                                controller.formatNominal(harga);
                            int denda = int.tryParse(controller
                                    .dendaController.text
                                    .replaceAll(".", "")) ??
                                0;
                            controller.totalMasukController.text =
                                controller.formatNominal(harga + denda);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          hint: Text("Pilih jumlah penghuni",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: 'Lato', fontSize: 14)),
                        );
                      }),
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
                              onTap: () =>
                                  controller.selectDatePeriode(context),
                              decoration: InputDecoration(
                                hintText: 'Tanggal Mulai',
                                hintStyle:
                                    TextStyle(fontFamily: 'Lato', fontSize: 14),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.tglSampaiController,
                              readOnly: true,
                              onTap: () =>
                                  controller.selectDatePeriode(context),
                              decoration: InputDecoration(
                                hintText: 'Tanggal Sampai',
                                hintStyle:
                                    TextStyle(fontFamily: 'Lato', fontSize: 14),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                              ),
                            ),
                          )
                        ],
                      ),
                      //row date start-end
                      //row bayar+status
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
                                    left: 8, top: 4, right: 8, bottom: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: appColor.backgroundColor3),
                                child: Center(
                                  child: Obx(() {
                                    return DropdownButtonFormField<String>(
                                      value: controller
                                              .selectedStatusBayar.value.isEmpty
                                          ? null
                                          : controller
                                              .selectedStatusBayar.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.selectedStatusBayar.value =
                                              value;
                                        }
                                      },
                                      items: controller.statusPembayaran
                                          .map((statusbayarlist) =>
                                              DropdownMenuItem(
                                                value: statusbayarlist,
                                                child: Text(
                                                  statusbayarlist,
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14),
                                                ),
                                              ))
                                          .toList(),
                                      hint: Text(
                                        'Status Bayar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 14),
                                      ),
                                      decoration: InputDecoration(
                                          hintText: '0',
                                          contentPadding:
                                              EdgeInsets.only(bottom: 10),
                                          border: InputBorder.none),
                                    );
                                  }),
                                ),
                                height: 40,
                                width: MediaQuery.sizeOf(context).width * 1 / 3,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      //row denda +date picker
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

                      //row uang muka +sisa
                      Obx(() {
                        if (controller.selectedStatusBayar.value ==
                            'Belum Lunas') {
                          final totalMasuk = int.tryParse(controller
                                  .totalMasukController.text
                                  .replaceAll(".", "")) ??
                              0;
                          final uangMuka = int.tryParse(controller
                                  .uangMukaController.text
                                  .replaceAll(".", "")) ??
                              0;

                          controller.sisaController.text =
                              controller.formatNominal(totalMasuk - uangMuka);
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
                        decoration: InputDecoration(
                            hintText: 'Catatan',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                                onPressed: () =>
                                    controller.catatanController.text = '',
                                icon: Icon(
                                  Icons.delete,
                                  color: appColor.outcome,
                                ))),
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
                          final periode = {
                            'mulai': Timestamp.fromDate(DateFormat('dd/MM/yyyy')
                                .parse(controller.tglMulaiController.text)),
                            'sampai': Timestamp.fromDate(
                                DateFormat('dd/MM/yyyy').parse(
                                    controller.tglSampaiController.text)),
                          };
                          final int uangMuka =
                              controller.selectedStatusBayar.value == 'Lunas'
                                  ? 0
                                  : int.tryParse(controller
                                          .uangMukaController.text
                                          .replaceAll(".", "")) ??
                                      0;

                          final int sisa =
                              controller.selectedStatusBayar.value == 'Lunas'
                                  ? 0
                                  : int.tryParse(controller.sisaController.text
                                          .replaceAll(".", "")) ??
                                      0;
                          final String catatan =
                              controller.catatanController.text.isEmpty
                                  ? controller.pemasukan.value.catatan
                                  : '-';
                          await controller.updateData(
                              controller.pemasukan.value.id,
                              catatan,
                              int.parse(controller.dendaController.text
                                  .replaceAll(".", "")),
                              controller.selectedKamar.value,
                              controller.selectedPenghuni.value,
                              controller.selectedProperti.value,
                              controller.jmlBulanController.text
                                  .replaceAll("Bulan", ""),
                              controller.selectedJmlPenghuni.value,
                              periode,
                              sisa,
                              controller.selectedStatusBayar.value,
                              int.parse(controller.totalMasukController.text
                                  .replaceAll(".", "")),
                              uangMuka);
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
              }
            }));
  }
}
