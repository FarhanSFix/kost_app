import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_room_controller.dart';

class AddRoomView extends GetView<AddRoomController> {
  const AddRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Kamar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            Text("Nomor Kamar",
                style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
            TextField(
              controller: controller.roomNumberController,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor kamar',
                hintStyle: TextStyle(color: Color(0xFF888888)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                value: controller.selectedStatus.value.isEmpty
                    ? null
                    : controller.selectedStatus.value,
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
                      controller.Facilities.length,
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
                                controller.Facilities[index],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )));
            }),
            Text("Luas Kamar (m2)",
                style: TextStyle(fontFamily: 'Lato', fontSize: 16)),
            TextField(
              controller: controller.wideController,
              decoration: InputDecoration(
                hintText: 'Masukkan luas kamar',
                hintStyle: TextStyle(color: Color(0xFF888888)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    onPressed: () {
                      _showAddPriceDialog(context);
                    },
                    icon: Icon(Icons.add_rounded))
              ],
            ),
            Obx(() {
              return Column(
                children: controller.hargaMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${entry.key}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              TextField(
                                controller: TextEditingController(
                                    text: entry.value.toString()),
                                onChanged: (value) {
                                  controller.updatePrice(
                                      entry.key, int.tryParse(value) ?? 0);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => controller.removePrice(entry.key),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: appColor.buttonColorPrimary,
                  foregroundColor: Color(0xFFFFFFFF),
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                try {
                  print(controller.hargaMap);
                  controller.addRoom(
                    nomorKamar: controller.roomNumberController.text,
                    status: controller.selectedStatus.value,
                    fasilitas: controller.Facilities,
                    luas: int.parse(controller.wideController.text),
                    harga: controller.hargaMap,
                    idproperti: controller.propertyId,
                  );
                } catch (e) {
                  Get.snackbar('Error', 'Terjadi kesalahan: $e');
                }
              },
              child: Text("Simpan",
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
            !controller.Facilities.contains(newFacility)) {
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
