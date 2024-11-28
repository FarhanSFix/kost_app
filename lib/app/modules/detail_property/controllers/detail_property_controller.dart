import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailPropertyController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final property = Get.arguments;
  // final Map<String, dynamic> property = Get.arguments as Map<String, dynamic>;
  final String propertyId = Get.arguments;

  var propertyData = Rxn<Map<String, dynamic>>();
  var isLoading = true.obs;

  late String propertyIdroom;

  Future<void> fetchProperty(String propertyId) async {
    try {
      isLoading.value = true;
      final snapshot =
          await firestore.collection('properti').doc(propertyId).get();
      if (snapshot.exists) {
        propertyData.value = snapshot.data();
      } else {
        propertyData.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat properti: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> countRooms(String propertyId) async {
    final querySnapshot = await firestore
        .collection('kamar')
        .where('id_properti', isEqualTo: propertyId)
        .get();
    return querySnapshot.size;
  }
}
