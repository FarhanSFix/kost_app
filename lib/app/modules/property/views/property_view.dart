import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/property_controller.dart';

class PropertyView extends GetView<PropertyController> {
  const PropertyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.offAllNamed(Routes.MAIN),
            icon: Icon(Icons.arrow_back_rounded)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Properti'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Mengambil stream dari controller
        final stream = controller.propertyStream.value;

        // Jika stream null, tampilkan indikator loading
        if (stream == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // StreamBuilder untuk membaca data dari Firestore
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            // Jika ada error, tampilkan pesan error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Terjadi kesalahan: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            // Jika sedang memuat data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Jika data kosong
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no_data.jpg",
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Belum Ada Data Properti',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Jika data ada
            final documents = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final property = documents[index];

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: appColor.backgroundColor1,
                      child: Icon(
                        Icons.home,
                        color: appColor.logoColor,
                      ),
                    ),
                    title: Text(
                      "${property['nama_properti']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "${property['kabupaten']}, ${property['provinsi']}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigasi ke halaman detail properti dengan membawa ID properti
                      Get.toNamed(Routes.DETAIL_PROPERTY,
                          arguments: property.id);
                    },
                  ),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_PROPERTY);
        },
        backgroundColor: appColor.buttonColorPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
