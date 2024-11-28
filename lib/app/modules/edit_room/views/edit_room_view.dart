// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_room_controller.dart';

class EditRoomView extends GetView<EditRoomController> {
  const EditRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('EditRoomView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: appColor.backgroundColor1,
                  child: Icon(
                    Icons.bed,
                    size: 46,
                    color: appColor.logoColor,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text("Nomor Kamar",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              TextField(
                controller:
                    TextEditingController(text: controller.room['nomor']),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text("Status Kamar",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedStatus.value = value;
                    }
                  },
                  items: controller.statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              }),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fasilitas",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  IconButton(
                      onPressed: () {
                        _showAddFacilityDialog(context);
                      },
                      icon: Icon(Icons.add_rounded))
                ],
              ),
              Obx(() {
                return Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: List.generate(
                      controller.facilities.length,
                      (index) => GestureDetector(
                          onTap: () {},
                          child: Chip(
                            onDeleted: () {
                              controller.removeFacility(index);
                            },
                            deleteIcon: Icon(Icons.close,
                                size: 18, color: Colors.black),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(color: Colors.black)),
                            label: Text(
                              controller.facilities[index],
                              style: const TextStyle(color: Colors.black),
                            ),
                          )),
                    ));
              }),
              Text("Luas Kamar (m2)",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
              TextField(
                controller: TextEditingController(
                    text: controller.room['luas'].toString()),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Harga/bulan",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
                  IconButton(
                      onPressed: controller.addPriceField,
                      icon: Icon(Icons.add_rounded))
                ],
              ),
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.roomPrices.length,
                  itemBuilder: (context, index) {
                    final entry =
                        controller.roomPrices.entries.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.key), // Key (e.g., "Orang 1")
                                TextField(
                                  controller:
                                      controller.roomPriceControllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onChanged: (value) {
                                    // Perbarui roomPrices saat pengguna mengedit
                                    controller.roomPrices[entry.key] =
                                        int.tryParse(value) ?? 0;
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (index > 0)
                            IconButton(
                              onPressed: () =>
                                  controller.removePriceField(index),
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ));
  }

  void _showAddFacilityDialog(BuildContext context) {
    String? newFacility;

    Get.defaultDialog(
      title: "Tambah Fasilitas",
      content: TextField(
        onChanged: (value) {
          newFacility = value;
        },
        decoration: InputDecoration(
          hintText: "Masukkan fasilitas baru",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textConfirm: "Tambah",
      onConfirm: () {
        if (newFacility != null &&
            newFacility!.isNotEmpty &&
            !controller.facilities.contains(newFacility)) {
          controller.addFacility(newFacility!);
        }
        Get.back();
      },
      textCancel: "Batal",
    );
  }
}
