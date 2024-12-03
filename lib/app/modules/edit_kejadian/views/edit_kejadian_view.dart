import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_kejadian_controller.dart';

class EditKejadianView extends GetView<EditKejadianController> {
  const EditKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Kejadian"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Penghuni",
                style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: controller.namaPenghuni.value,
                decoration: InputDecoration(
                  hintText: "Pilih nama penghuni",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                ),
                items: ["Farhan", "Penghuni 2", "Penghuni 3"]
                    .map((String value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.namaPenghuni.value = value!;
                },
                validator: (value) =>
                    value == null ? "Nama penghuni wajib dipilih" : null,
              ),
              const SizedBox(height: 16),
              Text("Kejadian",
                style: TextStyle(fontSize: 16)),
              TextFormField(
                initialValue: controller.kejadian.value,
                decoration: InputDecoration(
                  hintText: "Masukkan rincian kejadian",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) => controller.kejadian.value = value,
                validator: (value) =>
                    value!.isEmpty ? "Rincian kejadian wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              Text("Nominal",
                style: TextStyle(fontSize: 16)),
              TextFormField(
                initialValue: controller.nominal.value,
                decoration: InputDecoration(
                  hintText: "Masukkan nominal denda",
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.nominal.value = value,
                validator: (value) =>
                    value!.isEmpty ? "Nominal denda wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              Text("Bukti",
                style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () {
                  // Logic untuk upload foto
                  controller.bukti.value = "Foto berhasil diupload";
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Obx(() => controller.bukti.value == null
                        ? const Text("Upload Bukti Foto",
                        style: TextStyle(color: Color(0xFF888888)),
                        )
                        : Text(controller.bukti.value!)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,                      
                  ),
                  onPressed: () => controller.perbaruiData(),
                  child: const Text("Perbarui"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}