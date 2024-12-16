import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';

import '../controllers/detail_kejadian_controller.dart';

class DetailKejadianView extends GetView<DetailKejadianController> {
  const DetailKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Kejadian'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Obx(() {
              final kejadianvalue = controller.kejadianvalue.value;
              final penghuni = controller.penghuni.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField("Nama penghuni", penghuni.nama),
                  _buildReadOnlyField("Kejadian", kejadianvalue.kejadian),
                  _buildReadOnlyField("Nominal",
                      "Rp ${controller.formatNominal(kejadianvalue.nominal)}"),
                  _buildReadOnlyField("Status", "${kejadianvalue.status}"),
                  const Text(
                    "Bukti",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kejadianvalue.foto_bukti.isNotEmpty
                        ? Image(
                            image: MemoryImage(
                              controller.dataFromBase64String(
                                  kejadianvalue.foto_bukti),
                            ),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  "Gagal memuat gambar",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.image,
                                size: 50, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.EDIT_KEJADIAN,
                              arguments: kejadianvalue.id);
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
                          controller.deleteKejadian(kejadianvalue.id);
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
                ],
              );
            }),
          ),
        ));
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
