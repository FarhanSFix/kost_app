import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';
import '../controllers/detail_property_controller.dart';

class DetailPropertyView extends GetView<DetailPropertyController> {
  const DetailPropertyView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchProperty(controller.propertyId);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Properti'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.offAllNamed(Routes.PROPERTY),
                icon: Icon(Icons.close_rounded))
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final property = controller.propertyData.value;

          if (property == null) {
            return Center(child: Text('Properti tidak ditemukan.'));
          }

          return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const SizedBox(height: 30),
                    // Property Details
                    _buildDetailField(
                        "Nama Properti", property['nama_properti']),
                    _buildDetailField(
                        "Nama Pengelola", property['nama_pengelola']),
                    _buildDetailField(
                        "No. Telepon Pengelola", property['telepon_pengelola']),
                    _buildDetailField(
                      "Alamat",
                      "${property['provinsi']}, \n${property['kabupaten']} \n${property['kecamatan']}",
                      maxLines: 3,
                    ),
                    _buildDetailField(
                        "Detail Alamat", property['detail_alamat'],
                        maxLines: 2),
                    const SizedBox(height: 8),
                    FutureBuilder<int>(
                      future: controller.countRooms(controller.propertyId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text("Error loading room count."),
                              ),
                            ),
                          );
                        }

                        final roomCount = snapshot.data ?? 0;

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Jumlah Unit/Kamar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "$roomCount",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 35,
                                    width: MediaQuery.sizeOf(context).width *
                                        1 /
                                        4,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.ROOM,
                                            arguments: controller.propertyId);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Text(
                                          'Lihat Kamar',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.EDIT_PROPERTY,
                                arguments: controller.propertyId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(94, 42),
                          ),
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteProperti(controller.propertyId);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(94, 42),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ]));
        }));
  }

  Widget _buildDetailField(String label, String? value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Lato', fontSize: 16),
        ),
        const SizedBox(height: 4),
        TextField(
          readOnly: true,
          maxLines: maxLines,
          controller: TextEditingController(text: value ?? ''),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 17, vertical: 5)),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
