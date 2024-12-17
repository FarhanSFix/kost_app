import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final isAtBottom = false.obs; // Status apakah sudah scroll sampai bawah

  var indexStatistik = 0.obs; // 1 dan 0

  var belumBayar =
      <String>[].obs; // Observable list untuk penghuni yang belum bayar
  var belumLunas =
      <String>[].obs; // Observable list untuk penghuni yang belum lunas
  var lunas = <String>[].obs; // Observable list untuk penghuni yang sudah lunas

  var isSemuaLunas = false.obs; // Status semua penghuni sudah lunas atau belum

  var totalPenghuni = 0.obs;
  var statusPembayaran = ''.obs; // Lunas, belum_bayar, belum_lunas, kosong
  var totalBelumBayar = 0.obs;
  var totalBelumLunas = 0.obs;
  var totalLunas = 0.obs;

  final pemasukanBulanIni = 0.obs;
  final pengeluaranBulanIni = 0.obs;
  final pemasukanBulanLalu = 0.obs;
  final pengeluaranBulanLalu = 0.obs;
  final userName = ''.obs;

  var keuanganList = <Map<String, dynamic>>[].obs;

  // Hitung selisih
  int get selisihBulanIni =>
      pemasukanBulanIni.value - pengeluaranBulanIni.value;
  int get selisihBulanLalu =>
      pemasukanBulanLalu.value - pengeluaranBulanLalu.value;

  @override
  void onInit() {
    super.onInit();
    hitungStatistik();
    fetchKeuangan();
    listenToUserData();
    getJumlahStatusPembayaranBulanIni();
    print(totalLunas);
  }

  void listenToUserData() {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore.collection('users').doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        var fullName = data?['username'] ?? 'Nama Tidak Ditemukan';

        // Ambil hanya 2 kata pertama dari username
        var words = fullName.split(' ');
        userName.value =
            words.take(2).join(' '); // Gabungkan kembali 2 kata pertama
      }
    }, onError: (e) {
      Get.snackbar('Error', 'Gagal mengambil data user: $e');
    });
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(nominal).replaceAll(',', '.');
  }

  // Fungsi format tanggal
  String formatTanggal(DateTime tanggal) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(tanggal);
  }

  void hitungStatistik() async {
    DateTime now = DateTime.now();
    DateTime awalBulanIni = DateTime(now.year, now.month, 1);
    DateTime awalBulanLalu = DateTime(now.year, now.month - 1, 1);
    DateTime akhirBulanLalu = DateTime(now.year, now.month, 0);

    String? userId = auth.currentUser?.uid; // Ambil userId dari pengguna login

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    // Hitung pemasukan dan pengeluaran untuk bulan ini
    _hitungTotal(
      collection: 'pemasukan',
      awalBulan: awalBulanIni,
      akhirBulan: now,
      userId: userId,
      update: (total) => pemasukanBulanIni.value = total,
    );

    _hitungTotal(
      collection: 'pengeluaran',
      awalBulan: awalBulanIni,
      akhirBulan: now,
      userId: userId,
      update: (total) => pengeluaranBulanIni.value = total,
    );

    // Hitung pemasukan dan pengeluaran untuk bulan lalu
    _hitungTotal(
      collection: 'pemasukan',
      awalBulan: awalBulanLalu,
      akhirBulan: akhirBulanLalu,
      userId: userId,
      update: (total) => pemasukanBulanLalu.value = total,
    );

    _hitungTotal(
      collection: 'pengeluaran',
      awalBulan: awalBulanLalu,
      akhirBulan: akhirBulanLalu,
      userId: userId,
      update: (total) => pengeluaranBulanLalu.value = total,
    );
  }

  void _hitungTotal({
    required String collection,
    required DateTime awalBulan,
    required DateTime akhirBulan,
    required String userId,
    required Function(int) update,
  }) {
    FirebaseFirestore.instance
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('created_at', isGreaterThanOrEqualTo: awalBulan)
        .where('created_at', isLessThanOrEqualTo: akhirBulan)
        .snapshots()
        .listen((snapshot) {
      int total = snapshot.docs.fold(0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['status'] == 'Lunas') {
          return sum + (data['total_bayar'] as int);
        } else if (data['status'] == 'Belum Lunas') {
          return sum + (data['uang_muka'] as int);
        } else if (data['status'] == null) {
          return sum + (data['total_bayar'] as int);
        }
        return sum;
      });
      update(total); // Mengupdate nilai secara otomatis
    });
  }

  // List keuangan
  void fetchKeuangan() {
    String? userId = auth.currentUser?.uid; // Ambil userId dari pengguna login

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    firestore
        .collection('pemasukan')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((pemasukanSnapshot) {
      firestore
          .collection('pengeluaran')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((pengeluaranSnapshot) async {
        List<Map<String, dynamic>> pemasukan = [];

        for (var doc in pemasukanSnapshot.docs) {
          var data = doc.data();
          data['id'] = doc.id; // Tambahkan id dokumen pemasukan

          // Query nama penghuni berdasarkan id_penghuni
          var penghuniSnapshot = await firestore
              .collection('penghuni')
              .doc(data['id_penghuni'])
              .get();

          var propertiSnapshot = await firestore
              .collection('properti')
              .doc(data['id_properti'])
              .get();

          var kamarSnapshot =
              await firestore.collection('kamar').doc(data['id_kamar']).get();

          data['jenis'] = 'pemasukan'; // Tandai sebagai pemasukan
          data['judul'] = penghuniSnapshot.exists
              ? penghuniSnapshot.data()!['nama'] ?? 'tidak diketahui'
              : 'Tidak diketahui'; // Nama penghuni
          data['properti'] = propertiSnapshot.exists
              ? propertiSnapshot.data()!['nama_properti'] ?? 'tidak diketahui'
              : 'Tidak diketahui'; // Nama properti
          data['kamar'] = kamarSnapshot.exists
              ? kamarSnapshot.data()!['nomor'] ?? 'tidak diketahui'
              : 'tidak diketahui'; // Nama kamar
          data['catatan'] = data['catatan'] ?? '-'; // Catatan
          data['status'] = data['status']; // Status
          pemasukan.add(data);
        }

        // Proses pengeluaran
        List<Map<String, dynamic>> pengeluaran = [];

        for (var doc in pengeluaranSnapshot.docs) {
          var data = doc.data();
          data['id'] = doc.id; // Tambahkan id dokumen pengeluaran

          // Query nama kategori berdasarkan id_kategori
          var propertiSnapshot = await firestore
              .collection('properti')
              .doc(data['id_properti'])
              .get();

          data['jenis'] = 'pengeluaran'; // Tandai sebagai pengeluaran
          data['properti'] = propertiSnapshot.exists
              ? propertiSnapshot.data()!['nama_properti'] ?? '-'
              : '-'; // Nama properti
          data['catatan'] = data['catatan'] ?? '-'; // Catatan
          data['status'] = data['status']; // Status
          pengeluaran.add(data);
        }

        // Gabungkan dan urutkan data
        List<Map<String, dynamic>> combinedList = [
          ...pemasukan,
          ...pengeluaran
        ];
        combinedList.sort((a, b) {
          Timestamp t1 = a['created_at'] as Timestamp;
          Timestamp t2 = b['created_at'] as Timestamp;
          return t2.compareTo(t1); // Urutkan dari terbaru ke terlama
        });

        // Batasi data menjadi 5 item saja
        keuanganList.value = combinedList.take(5).toList();
      });
    });
  }

  DateTime getAwalBulanIni() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1); // Hari pertama bulan ini
  }

  DateTime getAkhirBulanIni() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 1)
        .subtract(const Duration(days: 1)); // Hari terakhir bulan ini
  }

  void getJumlahStatusPembayaranBulanIni() async {
    final firestore = FirebaseFirestore.instance;
    final awalBulan = getAwalBulanIni();
    final akhirBulan = getAkhirBulanIni();

    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan');
      return;
    }

    // Listen to penghuni updates
    firestore
        .collection('penghuni')
        .where('userId', isEqualTo: userId)
        .where('is_active', isEqualTo: true)
        .where('id_kamar', isNotEqualTo: "")
        .snapshots()
        .listen((penghuniSnapshot) async {
      totalPenghuni.value = penghuniSnapshot.docs.length;

      // Reset values
      totalBelumBayar.value = 0;
      totalBelumLunas.value = 0;
      totalLunas.value = 0;
      belumBayar.clear();
      belumLunas.clear();
      lunas.clear();

      // Collect all penghuni ids
      List<String> idPenghuniList =
          penghuniSnapshot.docs.map((e) => e.id).toList();

      // If idPenghuniList is empty, skip querying pemasukan
      if (idPenghuniList.isEmpty) {
        return;
      }

      // Listen to pemasukan updates for real-time changes
      firestore
          .collection('pemasukan')
          .where('id_penghuni', whereIn: idPenghuniList)
          .where('periode.mulai', isLessThanOrEqualTo: akhirBulan)
          .where('periode.sampai', isGreaterThanOrEqualTo: awalBulan)
          .snapshots()
          .listen((pemasukanSnapshot) {
        var penghuniStatus = Map<String, String>.fromIterable(
          idPenghuniList,
          key: (id) => id,
          value: (_) => 'Belum Bayar',
        );

        // Update the payment status based on pemasukan data
        for (var doc in pemasukanSnapshot.docs) {
          String idPenghuni = doc['id_penghuni'];
          String statusPembayaran = doc['status'];

          if (statusPembayaran == 'Lunas') {
            penghuniStatus[idPenghuni] = 'Lunas';
          } else {
            penghuniStatus[idPenghuni] = 'Belum Lunas';
          }
        }

        // Calculate totals for each status
        for (var penghuniDoc in penghuniSnapshot.docs) {
          String idPenghuni = penghuniDoc.id;
          String namaPenghuni = penghuniDoc['nama'];

          if (penghuniStatus[idPenghuni] == 'Lunas') {
            totalLunas.value++;
            lunas.add(namaPenghuni);
          } else if (penghuniStatus[idPenghuni] == 'Belum Lunas') {
            totalBelumLunas.value++;
            belumLunas.add(namaPenghuni);
          } else {
            totalBelumBayar.value++;
            belumBayar.add(namaPenghuni);
          }
        }

        // Update isSemuaLunas automatically when totals change
        isSemuaLunas.value =
            totalPenghuni.value > 0 && totalLunas.value == totalPenghuni.value;
      });
    });
  }

  void lunasi(String docId, String namaPenghuni, String idKamar) async {
    try {
      Get.defaultDialog(
          title: "Konfirmasi Pelunasan",
          middleText:
              "Apakah penghuni $namaPenghuni telah melakukan pelunasan?",
          onConfirm: () async {
            await FirebaseFirestore.instance
                .collection('pemasukan')
                .doc(docId)
                .update({'status': 'Lunas', 'uang_muka': 0, 'sisa': 0});

            await FirebaseFirestore.instance
                .collection('kamar')
                .doc(idKamar)
                .update({'status': 'Terisi'});
            Get.back();
            Get.snackbar('Berhasil', '$namaPenghuni sudah Lunas');
          },
          textConfirm: "Ya, saya yakin",
          textCancel: "Tidak");
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat melakukan pelunasan');
    }
  }

  void deletePemasukan(String docId, String idKamar) async {
    try {
      await FirebaseFirestore.instance
          .collection('pemasukan')
          .doc(docId)
          .delete();

      await FirebaseFirestore.instance
          .collection('kamar')
          .doc(idKamar)
          .update({'status': 'Tersedia'});
      Get.back();
      Get.snackbar('Berhasil', 'Data berhasil dihapus');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pemasukan');
    }
  }

  void deletePengeluaran(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengeluaran')
          .doc(docID)
          .delete();
      Get.back();
      Get.snackbar('Berhasil', 'Data berhasil dihapus');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Tidak dapat menghapus pengeluaran');
    }
  }
}
