import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/room_controller.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Kamar"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.offAllNamed(Routes.DETAIL_PROPERTY,
                  arguments: controller.propertyId),
              icon: Icon(Icons.close_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("Semua", "", controller),
                  SizedBox(width: 8),
                  _buildFilterChip("Terisi", "Terisi", controller),
                  SizedBox(width: 8),
                  _buildFilterChip("Dipesan", "Dipesan", controller),
                  SizedBox(width: 8),
                  _buildFilterChip("Diperbaiki", "Diperbaiki", controller),
                  SizedBox(width: 8),
                  _buildFilterChip("Tersedia", "Tersedia", controller),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => StreamBuilder<QuerySnapshot>(
                    stream: controller.getKamarStream(
                        controller.propertyId, controller.selectedStatus.value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("Tidak ada data kamar."));
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return Card(
                            // margin: const EdgeInsets.symmetric(
                            //   horizontal: 8.0,
                            //   vertical: 4.0,
                            // ),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: appColor.backgroundColor1,
                                  child: Icon(
                                    Icons.bed,
                                    color: appColor.logoColor,
                                  )),
                              title: Text("Kamar ${data['nomor']}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Harga: Rp ${data['harga']['1 orang']}/1 orang",
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(data['status']),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  data['status'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_ROOM,
                                    arguments: doc.id);
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_ROOM, arguments: controller.propertyId);
        },
        backgroundColor: appColor.buttonColorPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildFilterChips(RoomController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            _buildFilterChip("Semua", "", controller),
            _buildFilterChip("Terisi", "Terisi", controller),
            _buildFilterChip("Dipesan", "Dipesan", controller),
            _buildFilterChip("Diperbaiki", "Diperbaiki", controller),
            _buildFilterChip("Tersedia", "Tersedia", controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, String status, RoomController controller) {
    return Obx(() => FilterChip(
          label: Text(label),
          selected: controller.selectedStatus.value == status,
          onSelected: (_) => controller.filterByStatus(status),
        ));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Terisi":
        return Colors.red;
      case "Dipesan":
        return Colors.orange;
      case "Diperbaiki":
        return Colors.grey;
      case "Tersedia":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
