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
        final stream = controller.propertyStream.value;
        if (stream == Stream.empty()) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 1 / 5,
                        ),
                        Image.asset(
                          "assets/images/no_data.jpg",
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Belum Ada Data Properti',
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                        )
                      ],
                    ),
                  ),
                );
              }
              final documents = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final property = documents[index];

                  return Card(
                    color: appColor.backgroundColor2,
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
                      title: Text("${property['nama_properti']}"),
                      subtitle: Text(
                          "${property['kabupaten']}, ${property['provinsi']}"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PROPERTY,
                            arguments: property.id);
                      },
                    ),
                  );
                },
              );
            });
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
