import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_kejadian_controller.dart';

class EditKejadianView extends GetView<EditKejadianController> {
  const EditKejadianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditKejadianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditKejadianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
