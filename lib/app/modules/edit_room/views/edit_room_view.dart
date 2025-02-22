// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/edit_room_controller.dart';

class EditRoomView extends GetView<EditRoomController> {
  const EditRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Edit Kamar'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.offAllNamed(Routes.PROPERTY),
              icon: Icon(Icons.close_rounded))
        ],
      ),
      body: FutureBuilder(
        future: controller.getRoom(controller.idRoom),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var room = snapshot.data!;

            controller.roomNumberController.text = room['nomor'] ?? '';
            controller.selectedStatus.value = room['status'];
            controller.wideController.text = room['luas']?.toString() ?? '';
            controller.facilities.value =
                List<String>.from(room['fasilitas'] ?? []);

            if (room['harga'] is Map) {
              // Assign harga map
              controller.roomPrices
                  .assignAll(room['harga'] as Map<String, dynamic>);

              // Urutkan key berdasarkan angka yang ada di dalamnya
              final sortedKeys = controller.roomPrices.keys.toList()
                ..sort((a, b) {
                  // Ambil angka dari key dan bandingkan
                  final numberA = int.tryParse(a.split(' ')[0]) ?? 0;
                  final numberB = int.tryParse(b.split(' ')[0]) ?? 0;
                  return numberA.compareTo(numberB);
                });

              // Urutkan roomPrices berdasarkan sortedKeys
              final sortedRoomPrices = {
                for (var key in sortedKeys) key: controller.roomPrices[key]
              };

              // Assign hasil yang telah diurutkan
              controller.roomPrices.assignAll(sortedRoomPrices);

              // Tambahkan controller berdasarkan urutan
              controller.roomPriceControllers.clear();
              controller.roomPrices.forEach((key, value) {
                controller.roomPriceControllers
                    .add(TextEditingController(text: value.toString()));
              });
            } else {
              controller.roomPrices.assignAll({});
            }

            return SingleChildScrollView(
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
                    controller: controller.roomNumberController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
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
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side:
                                        const BorderSide(color: Colors.black)),
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
                    controller: controller.wideController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.number,
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
                          onPressed: () => _showAddPriceDialog(context),
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
                                    Text(entry.key),
                                    TextField(
                                      controller: controller
                                          .roomPriceControllers[index],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
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
                              if (index >= 0)
                                IconButton(
                                  onPressed: () =>
                                      controller.removePriceField(index),
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.buttonColorPrimary,
                        foregroundColor: Color(0xFFFFFFFF),
                        minimumSize: Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: controller.isLoading.value
                        ? null // Disable tombol jika sedang loading
                        : () async {
                            controller.updateRoom(
                                docId: controller.idRoom,
                                nomorKamar:
                                    controller.roomNumberController.text,
                                status: controller.selectedStatus.value,
                                fasilitas: controller.facilities,
                                luas: int.parse(controller.wideController.text),
                                harga: controller.roomPrices.map((key, value) =>
                                    MapEntry(
                                        key,
                                        value is int
                                            ? value
                                            : int.tryParse(value.toString()) ??
                                                0)),
                                idproperti: room['id_properti']);
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Perbarui",
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
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

  void _showAddPriceDialog(BuildContext context) {
    String? jumlahOrang;
    int? harga;

    Get.defaultDialog(
      title: 'Tambah Harga',
      content: Column(
        children: [
          TextField(
            onChanged: (value) {
              jumlahOrang = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: "Masukkan jumlah orang",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              harga = int.tryParse(value);
            },
            decoration: InputDecoration(
              hintText: "Masukkan harga",
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      textConfirm: "Tambah",
      onConfirm: () {
        if (jumlahOrang != null &&
            jumlahOrang!.isNotEmpty &&
            harga != null &&
            harga! > 0) {
          controller.addPrice(jumlahOrang!, harga!);
        } else {
          Get.snackbar("Error", "Masukkan data yang valid!");
        }
        Get.back();
      },
      textCancel: "Batal",
    );
  }
}
