import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kost_app/app/routes/app_pages.dart';

class DetailRoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final idRoom = Get.arguments;

  var data = Rxn<Map<String, dynamic>>();

  Future<Map<String, dynamic>?> getRoom(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('kamar').doc(id).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    } catch (e) {
      print("Error fetching room data: $e");
      return null;
    }
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  void deleteRoom(String docID) {
    try {
      Get.defaultDialog(
          title: "Hapus kamar",
          middleText: "Apakah anda yakin akan menghapus kamar ini?",
          onConfirm: () async {
            await firestore.collection('kamar').doc(docID).delete();
            Get.back();
            Get.snackbar('Berhasil', 'Kamar berhasil dihapus');
            Get.offAllNamed(Routes.PROPERTY);
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus kamar');
    }
  }
}
