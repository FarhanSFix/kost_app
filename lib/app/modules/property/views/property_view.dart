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
      appBar: AppBar(
        title: const Text('Properti'),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.properties.length,
          itemBuilder: (context, index) {
            final property = controller.properties[index];

            return Card(
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
                title: Text("${property['nameProperty']}"),
                subtitle: Text("${property['City']}, ${property['province']}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.toNamed(
                    Routes.DETAIL_PROPERTY,
                    arguments: property,
                  );
                },
              ),
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
