import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/data/model.dart';

class PenghuniController extends GetxController {
  var propertiList = <Properti>[].obs;
  var penghuniList = <Penghuni>[].obs;
  var kamarMap = <String, Kamar>{}.obs;

  var selectedProperti = 'Semua'.obs;
  var searchNama = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperti();
    fetchKamar();
    fetchPenghuni();
    super.onInit();
  }

  void fetchProperti() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final propertiQuery = await FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .get();

      propertiList.value = propertiQuery.docs
          .map((doc) => Properti.fromFireStore(doc.data(), doc.id))
          .toList();
    }
  }

  void fetchPenghuni() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final penghuniQuery = await FirebaseFirestore.instance
          .collection('penghuni')
          .where('id_properti',
              isEqualTo: selectedProperti.value == 'Semua'
                  ? null
                  : selectedProperti.value)
          .where("userId", isEqualTo: user.uid)
          .get();

      penghuniList.value = penghuniQuery.docs
          .map((doc) => Penghuni.fromFirestore(doc.data(), doc.id))
          .toList();
    }
  }

  void fetchKamar() async {
    final kamarQuery =
        await FirebaseFirestore.instance.collection('kamar').get();

    kamarMap.value = {
      for (var doc in kamarQuery.docs)
        doc.id: Kamar.fromFireStore(doc.data(), doc.id)
    };
  }

  void searchPenghuni(String keyword) {
    searchNama.value = keyword.toLowerCase();
    update();
  }

  String getNomorKamar(String idKamar) {
    return kamarMap[idKamar]?.nomor ?? 'Tidak Ditemukan';
  }

  String getNamaProperti(String idProperti) {
    final properti = propertiList.firstWhere(
      (item) => item.id == idProperti,
    );
    return properti.nama;
  }
}
