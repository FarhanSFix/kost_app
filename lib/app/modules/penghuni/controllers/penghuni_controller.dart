import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kost_app/app/data/model.dart';
import 'package:kost_app/app/routes/app_pages.dart';

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
          .where('is_active', isEqualTo: true)
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
    return kamarMap[idKamar]?.nomor ?? '-';
  }

  String getNamaProperti(String idProperti) {
    final properti = propertiList.firstWhereOrNull(
      (item) => item.id == idProperti,
    );
    return properti?.nama ?? '-';
  }

  void checkOut(String docID, String? idKamar) {
    if (idKamar != "") {
      try {
        Get.defaultDialog(
            title: "Checkout",
            middleText:
                "Apakah anda yakin akan melakukan checkout pada penghuni ini?",
            onConfirm: () async {
              await FirebaseFirestore.instance
                  .collection('penghuni')
                  .doc(docID)
                  .update({
                'is_active': false,
              });
              await FirebaseFirestore.instance
                  .collection('kamar')
                  .doc(idKamar)
                  .update({'status': 'Tersedia'});

              Get.back();
              Get.snackbar('Berhasil', 'Penghuni telah keluar dari kost');
              Get.offAllNamed(Routes.PENGHUNI);
            },
            textConfirm: "Ya, saya yakin",
            textCancel: "Tidak");
      } catch (e) {
        print(e);
        Get.snackbar('Error', 'Tidak dapat melakukan checkout');
      }
    } else {
      Get.snackbar("Error", "Penghuni ini belum masuk");
    }
  }
}
