import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kejadian_controller.dart';
// import '../models/kejadian_models.dart';

class KejadianView extends GetView<KejadianController> {
  final KejadianController controller = Get.find<KejadianController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kejadian'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            
            child: TextField(
              decoration: InputDecoration(
                hintText: "Nama Penghuni",
                hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          // Daftar kejadian
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.kejadianList.length,
                itemBuilder: (context, index) {
                  final kejadian = controller.kejadianList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        kejadian.namaPenghuni,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kejadian.deskripsi,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Nominal: Rp. ${kejadian.nominal}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => controller.detailKejadian(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeKejadian(index),
                      ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
          controller.addKejadian(),
          child: const Icon(Icons.add),
      ),
    );
  }
}
