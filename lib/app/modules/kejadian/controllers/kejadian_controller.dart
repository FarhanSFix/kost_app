import 'package:get/get.dart';

import '../models/kejadian_models.dart';

class KejadianController extends GetxController {
  // Objek observasi untuk daftar kejadian
  var kejadianList = <Kejadian>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Tambahkan data awal
    kejadianList.add(
      Kejadian(
        namaPenghuni: "Farhan",
        deskripsi: "Membuang Sampah Sembarangan",
        nominal: 5000,
      ),
    );
  }

  // Tambah kejadian baru
  void addKejadian() {
    Get.toNamed('/tambah-kejadian');
  }

  // Hapus kejadian berdasarkan indeks
  void removeKejadian(int index) {
    kejadianList.removeAt(index);
    Get.snackbar("Sukses", "Data kejadian berhasil dihapus",
    snackPosition: SnackPosition.BOTTOM);
  }

  void detailKejadian() {
    Get.toNamed('/detail-kejadian');
  }

  void hubungi() {
    Get.toNamed('/home');
  }
}