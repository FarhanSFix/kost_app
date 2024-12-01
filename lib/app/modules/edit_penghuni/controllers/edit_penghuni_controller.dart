import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPenghuniController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  void submitForm() {
    // Validate form fields (for simplicity, just check if fields are empty)
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields.");
      return;
    }

    // Process the form data (e.g., API call, save to database)
    Get.snackbar("Success", "Form submitted successfully.");
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    phoneController = TextEditingController();

    super.onInit();
  }

  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
