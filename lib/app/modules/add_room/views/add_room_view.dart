import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_room_controller.dart';

class AddRoomView extends GetView<AddRoomController> {
  const AddRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
