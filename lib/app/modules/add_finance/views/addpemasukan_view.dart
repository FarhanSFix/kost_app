// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_finance_controller.dart';

class AddpemasukanView extends GetView {
  final addfinC = Get.put(AddFinanceController());
  AddpemasukanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
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
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: addfinC.selectedPenghuni.value,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('Pilih penghuni',
                          style: TextStyle(fontFamily: 'Lato', fontSize: 14)),
                    ),
                    ...addfinC.penghuniList.map((penghuni) {
                      return DropdownMenuItem(
                        value: penghuni.id,
                        child: Text(penghuni.nama),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    addfinC.selectedPenghuni.value = value ?? '';
                    addfinC.dendaController.text = '';
                    addfinC.fetchKejadian(
                        addfinC.selectedPenghuni.value, 'Belum dibayar');
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
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return DropdownButtonFormField<String>(
                        value: addfinC.selectedProperti.value,
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('Pilih properti',
                                style: TextStyle(
                                    fontFamily: 'Lato', fontSize: 14)),
                          ),
                          ...addfinC.propertiList.map((properti) {
                            return DropdownMenuItem(
                              value: properti.id,
                              child: Text(properti.nama),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          addfinC.selectedProperti.value = value ?? '';
                          addfinC.selectedKamar.value = '';
                          addfinC.kamarList.clear();
                          addfinC.fetchKamar(
                              addfinC.selectedProperti.value, 'Tersedia');
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
                      return DropdownButtonFormField<String>(
                        value: addfinC.selectedKamar.value.isEmpty
                            ? null // Jika nilai kosong, atur sebagai null
                            : addfinC.selectedKamar.value,
                        items: [
                          DropdownMenuItem(
                            value: '', // Tambahkan nilai default
                            child: Text('Pilih kamar'),
                          ),
                          ...addfinC.kamarList.map((kamar) {
                            return DropdownMenuItem(
                              value: kamar.id,
                              child: Text(kamar.nomor), // Tampilkan nomor kamar
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          addfinC.selectedKamar.value = value ?? '';
                          addfinC.selectedJmlPenghuni.value = '';
                          addfinC.jmlPenghuniList.clear();
                          addfinC.fetchHarga(addfinC.selectedKamar.value);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        hint: Text('Pilih kamar',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Lato', fontSize: 14)),
                      );
                    }),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              // untuk jumlah penghuni
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: addfinC.selectedJmlPenghuni.value.isEmpty
                      ? null // Jika nilai kosong, atur sebagai null
                      : addfinC.selectedJmlPenghuni.value,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('Jumlah penghuni'),
                    ),
                    ...addfinC.jmlPenghuniList.map((jmlpenghuni) {
                      return DropdownMenuItem(
                        value: jmlpenghuni.toString(),
                        child: Text(jmlpenghuni),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    addfinC.selectedJmlPenghuni.value = value ?? '';
                    addfinC.totalMasukController.text = '';
                    addfinC.keyHarga.value = addfinC.selectedJmlPenghuni.value;

                    int harga = addfinC
                            .kamarvalue.value.harga[addfinC.keyHarga.value] ??
                        0;
                    addfinC.totalMasukController.text =
                        addfinC.formatNominal(harga);
                    int denda = int.tryParse(
                            addfinC.dendaController.text.replaceAll(".", "")) ??
                        0;
                    addfinC.totalMasukController.text =
                        addfinC.formatNominal(harga + denda);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  hint: Text("Pilih jumlah penghuni",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Lato', fontSize: 14)),
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
                  controller: addfinC.jmlbulanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Jumlah bulan',
                      hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 14),
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
                      controller: addfinC.tglMulaiController,
                      readOnly: true,
                      onTap: () => addfinC.selectDatePeriode(context),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Mulai',
                        hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextField(
                      controller: addfinC.tglSampaiController,
                      readOnly: true,
                      onTap: () => addfinC.selectDatePeriode(context),
                      decoration: InputDecoration(
                        hintText: 'Tanggal Sampai',
                        hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rp'),
                            Expanded(
                              child: TextField(
                                controller: addfinC.totalMasukController,
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
                              value: addfinC.selectedStatusBayar.value.isEmpty
                                  ? null
                                  : addfinC.selectedStatusBayar.value,
                              onChanged: (value) {
                                if (value != null) {
                                  addfinC.selectedStatusBayar.value = value;
                                }
                              },
                              items: addfinC.statusBayar
                                  .map((statusbayarlist) => DropdownMenuItem(
                                        value: statusbayarlist,
                                        child: Text(
                                          statusbayarlist,
                                          style: TextStyle(
                                              fontFamily: 'Lato', fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              hint: Text(
                                'Status Bayar',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontFamily: 'Lato', fontSize: 14),
                              ),
                              decoration: InputDecoration(
                                  hintText: '0',
                                  contentPadding: EdgeInsets.only(bottom: 10),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rp'),
                              Expanded(
                                child: TextField(
                                  controller: addfinC.dendaController,
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
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: addfinC.isDendaChecked.value,
                              onChanged: (value) {
                                addfinC.isDendaChecked.value = value ?? false;
                              },
                            )),
                        Text(
                          'Bayar Denda',
                          style: TextStyle(fontFamily: 'Lato', fontSize: 14),
                        ),
                      ],
                    ),
                  ]),
              SizedBox(
                height: 8,
              ),

              //row uang muka +sisa
              Obx(() {
                if (addfinC.selectedStatusBayar.value == 'Belum Lunas') {
                  final totalMasuk = int.tryParse(addfinC
                          .totalMasukController.text
                          .replaceAll(".", "")) ??
                      0;
                  final uangMuka = int.tryParse(addfinC.uangMukaController.text
                          .replaceAll(".", "")) ??
                      0;

                  addfinC.sisaController.text =
                      addfinC.formatNominal(totalMasuk - uangMuka);

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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rp'),
                                Expanded(
                                  child: TextField(
                                    controller: addfinC.uangMukaController,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rp'),
                                Expanded(
                                  child: TextField(
                                    controller: addfinC.sisaController,
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
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: addfinC.catatanController,
                decoration: InputDecoration(
                    hintText: 'Catatan',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                        onPressed: () => addfinC.catatanController.text = '',
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
                        .parse(addfinC.tglMulaiController.text)),
                    'sampai': Timestamp.fromDate(DateFormat('dd/MM/yyyy')
                        .parse(addfinC.tglSampaiController.text)),
                  };
                  final int uangMuka =
                      addfinC.selectedStatusBayar.value == 'Lunas'
                          ? 0
                          : int.tryParse(addfinC.uangMukaController.text
                                  .replaceAll(".", "")) ??
                              0;

                  final int sisa = addfinC.selectedStatusBayar.value == 'Lunas'
                      ? 0
                      : int.tryParse(addfinC.sisaController.text
                              .replaceAll(".", "")) ??
                          0;
                  if (addfinC.catatanController.text == '') {
                    addfinC.catatanController.text = '-';
                  }
                  addfinC.tambahPemasukan(
                      addfinC.selectedPenghuni.value,
                      addfinC.selectedProperti.value,
                      addfinC.selectedKamar.value,
                      addfinC.selectedJmlPenghuni.value,
                      addfinC.jmlbulanController.text,
                      periode,
                      int.parse(addfinC.totalMasukController.text
                          .replaceAll(".", "")),
                      addfinC.selectedStatusBayar.value,
                      int.tryParse(addfinC.dendaController.text
                              .replaceAll(".", "")) ??
                          0,
                      uangMuka,
                      sisa,
                      addfinC.catatanController.text);
                },
                child: Text("Bayar",
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
