import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                const Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                CircleAvatar(
                  backgroundColor: appColor.backgroundColor2,
                  radius: 72.5,
                  child: controller.userPhoto.value.isNotEmpty
                      ? Container(
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(
                                base64Decode(controller.userPhoto.value),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: appColor.logoColor,
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  controller.userName.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userPhone.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: appColor.backgroundColor2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.totalProperti.value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Properti',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: VerticalDivider(
                          color: appColor.logoColor,
                          thickness: 1,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.totalPenghuni.value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Penghuni',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.dialog(
                            barrierDismissible: false,
                            AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text(
                                "Edit Profile",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: controller.pickImage,
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Obx(
                                            () => Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                      appColor.backgroundColor2,
                                                  backgroundImage: (controller
                                                          .selectedPhoto
                                                          .value
                                                          .path
                                                          .isNotEmpty)
                                                      ? FileImage(controller
                                                          .selectedPhoto.value)
                                                      : (controller.userPhoto
                                                              .value.isNotEmpty)
                                                          ? MemoryImage(
                                                              base64Decode(
                                                                  controller
                                                                      .userPhoto
                                                                      .value))
                                                          : null,
                                                ),
                                                if (controller.selectedPhoto
                                                        .value.path.isEmpty &&
                                                    controller.userPhoto.value
                                                        .isEmpty)
                                                  const Positioned.fill(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 50,
                                                      color: appColor.logoColor,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller:
                                          controller.usernameController.value,
                                      decoration: InputDecoration(
                                        labelText: "Username",
                                        hintText: "Enter your username",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      controller:
                                          controller.phoneController.value,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: "Phone Number",
                                        hintText: "Enter your phone number",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.selectedPhoto.value = File('');
                                    controller.usernameController.value.text =
                                        controller.userName.value;
                                    controller.phoneController.value.text =
                                        controller.userPhone.value;
                                    Get.back();
                                  },
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.black54)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        appColor.buttonColorPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    String updatedUsername = controller
                                        .usernameController.value.text
                                        .trim();
                                    String updatedPhone = controller
                                        .phoneController.value.text
                                        .trim();

                                    if (updatedUsername.isEmpty ||
                                        updatedPhone.isEmpty) {
                                      Get.snackbar(
                                        "Error",
                                        "Both fields must be filled!",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                      return;
                                    }

                                    controller.updateUserProfile(
                                      username: updatedUsername,
                                      phone: updatedPhone,
                                      profilePhoto:
                                          controller.selectedPhoto.value,
                                    );
                                    Get.back();
                                  },
                                  child: Text("Save",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.buttonColorEdit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
                                "Konfirmasi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                "Apakah Anda yakin ingin keluar?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColor.buttonColorDelete,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.logout();
                                  },
                                  child: const Text(
                                    "Keluar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.buttonColorDelete,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
