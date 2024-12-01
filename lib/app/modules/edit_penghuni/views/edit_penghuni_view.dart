import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_penghuni_controller.dart';

class EditPenghuniView extends GetView<EditPenghuniController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Get.back(result: 'value');
              },
              icon: Icon(Icons.close)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ListView(children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color.fromARGB(255, 211, 236, 255),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: 15,
                    child: const Icon(
                      Icons.edit_note,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Nama Lengkap",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              child: TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Farhan',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No. Telepon",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              child: TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: '62888888888'),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Properti",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: "Properti A", child: Text("Kos Iqbal")),
                DropdownMenuItem(
                    value: "Properti B", child: Text("Kos Farhan")),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Kos Iqbal",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No.Kamar",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: "Kamar 1", child: Text("Kamar 1")),
                DropdownMenuItem(value: "Kamar 2", child: Text("Kamar 2")),
              ],
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Kamar 1",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Unggah foto KTP/Kartu Pelajar",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white),
              child: const Text("Perbarui"),
            ),
          ]),
        ),
      ),
    );
  }
}
