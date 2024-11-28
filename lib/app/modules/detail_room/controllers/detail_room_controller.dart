import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
}
