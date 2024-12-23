import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var propertyList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    readProperty();
  }

  readProperty() {
    String? userId = auth.currentUser?.uid; // Ambil userId dari pengguna login

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore
        .collection('properti')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      propertyList.assignAll(
        snapshot.docs.map((e) {
          final data = e.data();
          data['id_properti'] = e.id; // Tambahkan id properti
          return data;
        }).toList(),
      );
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data properti: $e');
    });
  }
}
