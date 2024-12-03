import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_kejadian_controller.dart';

class DetailKejadianView extends GetView<DetailKejadianController> {
  const DetailKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kejadian"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Penghuni
            Text("Nama Penghuni",
                style: TextStyle(fontSize: 16)),
            TextFormField(
              initialValue: controller.namaPenghuni.value,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Pilih nama penghuni",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Text("Kejadian",
                style: TextStyle(fontSize: 16)),
            TextFormField(
              initialValue: controller.kejadian.value,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Masukkan rincian kejadian",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Text("Nominal",
                style: TextStyle(fontSize: 16)),
            TextFormField(
              initialValue: controller.nominal.value,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Masukkan nominal denda",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            // Bukti
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(controller.bukti.value),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Edit dan Hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Edit
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => controller.editData(),
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 70),
                // Tombol Hapus
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,                      
                    ),
                    onPressed: () => controller.hapusData(),
                    child: const Text("Hapus"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}