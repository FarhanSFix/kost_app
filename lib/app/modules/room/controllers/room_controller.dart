import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String propertyId = Get.arguments;
  var selectedStatus = ''.obs;

  Stream<QuerySnapshot> getKamarStream(String idProperti, String status) {
    var query = firestore
        .collection('kamar')
        .where('id_properti', isEqualTo: idProperti);
    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }
    return query.snapshots();
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
  }
}
