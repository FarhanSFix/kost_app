import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    query = query.orderBy("nomor");
    return query.snapshots();
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(nominal).replaceAll(',', '.');
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
  }
}
