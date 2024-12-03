import 'package:get/get.dart';

class DetailKejadianController extends GetxController {
 // Data kejadian (contoh hardcoded, nanti dapat diintegrasikan dengan API/database)
  final namaPenghuni = "Farhan".obs;
  final kejadian = "Membuang Sampah Sembarangan".obs;
  final nominal = "5000".obs;
  final bukti = "Bukti Foto".obs;

  // Method untuk menghapus data kejadian
  void hapusData() {
    // Logika hapus data (contoh: API call)
    Get.toNamed('/kejadian'); // Kembali ke halaman sebelumnya
    Get.snackbar("Sukses", "Data kejadian berhasil dihapus",
        snackPosition: SnackPosition.BOTTOM);
  }

  void editData() {
    Get.toNamed('/edit-kejadian');
  }
}