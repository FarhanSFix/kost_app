import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyController extends GetxController {
  final propertyStream =
      Stream<QuerySnapshot<Map<String, dynamic>>>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  void fetchProperties() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      propertyStream.value = FirebaseFirestore.instance
          .collection('properti')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }
}
