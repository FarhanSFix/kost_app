import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';
import '../controllers/detail_property_controller.dart';

class DetailPropertyView extends GetView<DetailPropertyController> {
  const DetailPropertyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPropertyView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                "Nama Properti", controller.property['nameProperty']),
            _buildDetailField(
                "Nama Pengelola", controller.property['managerProperty']),
            _buildDetailField("No. Telepon Pengelola",
                controller.property['telpManagerProperty']),
            _buildDetailField(
              "Alamat",
              "${controller.property['province']}, \n${controller.property['City']} \n${controller.property['district']}",
              maxLines: 3,
            ),
            _buildDetailField(
                "Detail Alamat", controller.property['addressDetail']),
            const SizedBox(height: 8),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.EDIT_PROPERTY,
                        arguments: controller.property);
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
                    print("Hapus button pressed");
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
            const Divider(),
            // Filter and Rooms
            Text(
              "Jumlah Unit/Kamar = ${controller.property["rooms"] != null ? controller.property["rooms"].length : 0}",
            ),
            const SizedBox(height: 8),
            _buildFilterChips(controller),
            const SizedBox(height: 16),
            // Rooms List
            Obx(
              () {
                final rooms = controller.filteredRooms;
                return ListView.builder(
                  shrinkWrap:
                      true, // Allows ListView to adapt to available space
                  physics:
                      const NeverScrollableScrollPhysics(), // Disables ListView scrolling
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Card(
                      // margin: const EdgeInsets.symmetric(
                      //   horizontal: 8.0,
                      //   vertical: 4.0,
                      // ),
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: appColor.backgroundColor1,
                            child: Icon(
                              Icons.bed,
                              color: appColor.logoColor,
                            )),
                        title: Text("Kamar ${room['numberRoom']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Harga: Rp ${room['prices'][0]['1 orang']}/1 orang",
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(room['status']),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            room['status'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_ROOM, arguments: room);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_ROOM);
        },
        backgroundColor: appColor.buttonColorPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
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
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFilterChips(DetailPropertyController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            _buildFilterChip("Semua", "", controller),
            _buildFilterChip("Terisi", "Terisi", controller),
            _buildFilterChip("Dipesan", "Dipesan", controller),
            _buildFilterChip("Diperbaiki", "Diperbaiki", controller),
            _buildFilterChip("Tersedia", "Tersedia", controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, String filterValue, DetailPropertyController controller) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: controller.selectedFilter.value == filterValue,
        onSelected: (value) =>
            controller.selectedFilter.value = value ? filterValue : '',
        selectedColor: Colors.blue.shade100,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Terisi":
        return Colors.red;
      case "Dipesan":
        return Colors.orange;
      case "Diperbaiki":
        return Colors.grey;
      case "Tersedia":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
