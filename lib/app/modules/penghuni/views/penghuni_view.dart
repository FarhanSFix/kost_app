// File: dropdown_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/modules/detail_penghuni/views/detail_penghuni_view.dart';
import 'package:kost_app/app/modules/penghuni/controllers/penghuni_controller.dart';
import '../../../routes/app_pages.dart'; // Pastikan path ini sesuai dengan file routes Anda
import 'package:provider/provider.dart';

class PenghuniView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PenghuniController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Penghuni'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownTextField(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var test = await Get.toNamed(Routes.ADD_PENGHUNI);
            print(test);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: CircleBorder(),
          backgroundColor: Colors.blue, // Optional: Customize the button color
        ),
      ),
    );
  }
}

class DropdownTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PenghuniController>(
      builder: (context, controller, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
              child: TextField(
                readOnly: true,
                controller:
                    TextEditingController(text: controller.selectedValue),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.arrow_drop_down), // Ikon dropdown
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onTap: () {
                  // Ketika TextField diketuk, tampilkan dialog dropdown
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Pilih Properti'),
                        content: Container(
                          width: double.maxFinite,
                          height: 150,
                          child: ListView.builder(
                            itemCount: controller.options.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(controller.options[index]),
                                onTap: () {
                                  controller.updateSelectedValue(
                                      controller.options[index]);
                                  Navigator.pop(
                                      context); // Tutup dialog setelah memilih
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            // TextFormField untuk pencarian nama penghuni
            Container(
              height: 45,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  hintText: "Nama Penghuni",
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: controller.search,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Pindah ke halaman detail saat card diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPenghuniView(),
                        ),
                      );
                    },
                    // Card untuk menampilkan informasi penghuni
                    child: _buildCard(
                        'Farhan', 'Kost Iqbal', 'Kamar 1', 'Bulanan'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk membangun card informasi penghuni
  Widget _buildCard(String name, String kostName, String room, String type) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Bagian kiri (ikon profil)
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.person, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 10),

            // Bagian tengah (teks informasi)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$kostName\n$room\n$type',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Bagian kanan (tombol)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Action for Check-out
                      },
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text('Check-out',
                          style: TextStyle(color: Colors.red, fontSize: 10)),
                    ),
                    IconButton(
                      onPressed: () async {
                        var test = await Get.toNamed(Routes.EDIT_PENGHUNI);
                        print(test);
                      },
                      icon: Icon(Icons.edit, color: Colors.grey),
                      iconSize: 20,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Action for WhatsApp contact
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 84, 215, 89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Icon(Icons.call, color: Colors.white),
                  label: Text('Hubungi',
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
