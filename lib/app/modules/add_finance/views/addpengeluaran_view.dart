import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_finance_controller.dart';

class AddpengeluaranView extends GetView {
  final addfinC = Get.put(AddFinanceController());
  AddpengeluaranView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                controller: addfinC.tanggalController,
                readOnly: true,
                onTap: () => addfinC.selectDate(context),
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
                  value: addfinC.selectedProperti2.value,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('Pilih properti'),
                    ),
                    ...addfinC.propertiList.map((properti) {
                      return DropdownMenuItem(
                        value: properti.id,
                        child: Text(properti.nama),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    addfinC.selectedProperti2.value = value ?? '';
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
                controller: addfinC.judulController,
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
                  value: addfinC.selectedKategori.value.isEmpty
                      ? null
                      : addfinC.selectedKategori.value,
                  onChanged: (value) {
                    if (value != null) {
                      addfinC.selectedKategori.value = value;
                    }
                  },
                  items: addfinC.kategori
                      .map((kategori) => DropdownMenuItem(
                            value: kategori,
                            child: Text(kategori),
                          ))
                      .toList(),
                  hint: Text(
                    'Kategori Pengeluaran',
                    textAlign: TextAlign.center,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        controller: addfinC.totalKeluarController,
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
              Obx(() {
                return Row(
                  children: [
                    addfinC.files.value.path != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(addfinC.files.value.path),
                              height: 150,
                              width: 300,
                              fit: BoxFit.cover,
                            ))
                        : GestureDetector(
                            onTap: () async {
                              await addfinC.getImage(true);
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
                        child: addfinC.files.value.path != ""
                            ? IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  addfinC.files.value = XFile("");
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
                    minimumSize: Size(double.infinity, 42),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  if (addfinC.tanggalController.text.isEmpty) {
                    Get.snackbar(
                        'Input Error', 'Tanggal mulai dan sampai harus diisi!',
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent);
                    return;
                  }
                  DateTime tanggalParsed = DateFormat('dd/MM/yyyy')
                      .parse(addfinC.tanggalController.text);
                  addfinC.tambahPengeluaran(
                      addfinC.selectedProperti2.value,
                      File(addfinC.files.value.path),
                      addfinC.judulController.text,
                      addfinC.selectedKategori.value,
                      tanggalParsed,
                      int.parse(addfinC.totalKeluarController.text));
                },
                child: Text("Simpan",
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          )),
    );
  }
}
