import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ResidentHistoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var residentList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    readResident();
  }

  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(tanggal);
  }

  readResident() {
    String? userId = auth.currentUser?.uid; // Ambil userId dari pengguna login

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore
        .collection('penghuni')
        .where('userId', isEqualTo: userId)
        .where('id_properti', isEqualTo: Get.arguments['propertyId'])
        .where('is_active', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      residentList.assignAll(snapshot.docs.map((e) => e.data()).toList());
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data penghuni: $e');
    });
  }
}
