import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/data/model.dart';

class KejadianController extends GetxController {
  var searchNama = ''.obs;
  var kejadianList = <Kejadian>[].obs;
  var penghuniList = <Penghuni>[].obs;

  void searchPenghuni(String keyword) {
    searchNama.value = keyword.toLowerCase();
    update();
  }

  void fetchPenghuni() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final penghuniQuery =
          await FirebaseFirestore.instance.collection('penghuni').get();

      penghuniList.value = penghuniQuery.docs
          .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
          .toList();

      print("Penghuni: ${penghuniList.length}"); // Debug log
    }
  }

  void fetchKejadian() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final kejadianQuery = await FirebaseFirestore.instance
          .collection('kejadian')
          .where("userId", isEqualTo: user.uid)
          .get();

      kejadianList.value = kejadianQuery.docs
          .map((doc) => Kejadian.fromFireStore(doc.data(), doc.id))
          .toList();

      print("Kejadian: ${kejadianList.length}"); // Debug log
    }
  }

  @override
  void onInit() {
    fetchPenghuni();
    fetchKejadian();
    super.onInit();
  }
}
