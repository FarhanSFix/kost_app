import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var indexStatistik = 0.obs;

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
        return sum + (doc['total_bayar'] as int);
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
          var data = doc.data() as Map<String, dynamic>;

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
          pemasukan.add(data);
        }

        // Proses pengeluaran
        List<Map<String, dynamic>> pengeluaran = [];

        for (var doc in pengeluaranSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

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
          pengeluaran.add(data);
        }

        // Gabungkan dan urutkan data
        keuanganList.value = [...pemasukan, ...pengeluaran];
        keuanganList.sort((a, b) {
          Timestamp t1 = a['created_at'] as Timestamp;
          Timestamp t2 = b['created_at'] as Timestamp;
          return t2.compareTo(t1); // Urutkan dari terbaru ke terlama
        });
      });
    });
  }
}
