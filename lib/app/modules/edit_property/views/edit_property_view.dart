// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_property_controller.dart';

class EditPropertyView extends GetView<EditPropertyController> {
  const EditPropertyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAllNamed(Routes.PROPERTY),
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: FutureBuilder(
        future: controller.getProperty(controller.property),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var property = snapshot.data!;
            controller.namePropertyController.text =
                '${property['nama_properti']}';
            controller.nameManagerController.text =
                '${property['nama_pengelola']}';
            controller.telpManagerController.text =
                '${property['telepon_pengelola']}';
            controller.provinceController.text = '${property['provinsi']}';
            controller.cityController.text = '${property['kabupaten']}';
            controller.districtPropertyController.text =
                '${property['kecamatan']}';
            controller.detailAddressPropertyController.text =
                '${property['detail_alamat']}';
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: appColor.backgroundColor1,
                        child: Icon(
                          Icons.home,
                          size: 46,
                          color: appColor.logoColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Nama Properti",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.namePropertyController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama properti',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Nama Pengelola",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.nameManagerController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama pengelola',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("No. Telepon. Pengelola",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.telpManagerController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nomor telepon pengelola',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Provinsi",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.provinceController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Provinsi',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Kabupaten",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.cityController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kabupaten',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Kecamatan",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.districtPropertyController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kecamatan',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Detail  Alamat",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                    TextField(
                      controller: controller.detailAddressPropertyController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan detail alamat',
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
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
                      onPressed: () {
                        controller.updateProperty(
                            docId: controller.property,
                            namaProperti:
                                controller.namePropertyController.text,
                            namaPengelola:
                                controller.nameManagerController.text,
                            detailAlamat:
                                controller.detailAddressPropertyController.text,
                            kabupaten: controller.cityController.text,
                            kecamatan:
                                controller.districtPropertyController.text,
                            provinsi: controller.provinceController.text,
                            teleponPengelola:
                                controller.telpManagerController.text);
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
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}