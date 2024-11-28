import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable untuk data user
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var totalProperti = 0.obs;
  var totalKamar = 0.obs;

  var isLoading = true.obs; // Tambahkan loading state

  // Referensi Firestore dan FirebaseAuth
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchCounts();
  }

  // Fungsi untuk mengambil data user berdasarkan userId login
  void fetchUserData() async {
    // try {
    //   String? userId =
    //       auth.currentUser?.uid; // Ambil userId dari pengguna login

    //   userId = 'qDAkcou7gEOGbqCrRFcTg1YSgdI2';

    //   if (userId == null) {
    //     Get.snackbar('Error', 'User tidak ditemukan');
    //     return;
    //   }

    //   var userDoc = await firestore.collection('users').doc(userId).get();

    //   if (userDoc.exists) {
    //     var data = userDoc.data();
    //     userName.value = data?['username'] ?? 'Nama Tidak Ditemukan';
    //     userEmail.value = data?['email'] ?? 'Email Tidak Ditemukan';
    //     userPhone.value = data?['telepon'] ?? 'Nomor Tidak Ditemukan';
    //   } else {
    //     Get.snackbar('Error', 'Data user tidak ditemukan');
    //   }
    // } catch (e) {
    //   Get.snackbar('Error', 'Gagal mengambil data user: $e');
    // }
  }

  // Fungsi untuk menghitung jumlah properti dan kamar
  void fetchCounts() async {
    try {
      var propertiSnapshot = await firestore.collection('properti').get();
      totalProperti.value = propertiSnapshot.size;

      var kamarSnapshot = await firestore.collection('kamar').get();
      totalKamar.value = kamarSnapshot.size;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data properti atau kamar: $e');
    } finally {
      isLoading.value = false; // Akhiri loading
    }
  }

  // Fungsi untuk logout
  void logout() async {
    try {
      await auth.signOut();
      Get.snackbar('Logout', 'Anda telah keluar');
      Get.offAllNamed('/login'); // Navigasi ke halaman login
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }

  // Fungsi untuk navigasi ke halaman edit profil
  void editProfile() {}
}
