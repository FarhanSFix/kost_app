import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_room_controller.dart';

class AddRoomView extends GetView<AddRoomController> {
  const AddRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddRoomView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddRoomView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
