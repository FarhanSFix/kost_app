import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var indexStatistik = 0.obs;

  final pemasukanBulanIni = 0.obs;
  final pengeluaranBulanIni = 0.obs;
  final pemasukanBulanLalu = 0.obs;
  final pengeluaranBulanLalu = 0.obs;

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
  }

  String formatNominal(int nominal) {
    final formatter = NumberFormat('#,###', 'id_ID');
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

    // Hitung pemasukan dan pengeluaran untuk bulan ini
    pemasukanBulanIni.value = await _hitungTotal(
      collection: 'pemasukan',
      awalBulan: awalBulanIni,
      akhirBulan: now,
    );

    pengeluaranBulanIni.value = await _hitungTotal(
      collection: 'pengeluaran',
      awalBulan: awalBulanIni,
      akhirBulan: now,
    );

    // Hitung pemasukan dan pengeluaran untuk bulan lalu
    pemasukanBulanLalu.value = await _hitungTotal(
      collection: 'pemasukan',
      awalBulan: awalBulanLalu,
      akhirBulan: akhirBulanLalu,
    );

    pengeluaranBulanLalu.value = await _hitungTotal(
      collection: 'pengeluaran',
      awalBulan: awalBulanLalu,
      akhirBulan: akhirBulanLalu,
    );
  }

  Future<int> _hitungTotal({
    required String collection,
    required DateTime awalBulan,
    required DateTime akhirBulan,
  }) async {
    print("Mengambil data dari koleksi: $collection");
    print(
        "Rentang waktu: ${awalBulan.toIso8601String()} - ${akhirBulan.toIso8601String()}");

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('created_at', isGreaterThanOrEqualTo: awalBulan)
        .where('created_at', isLessThanOrEqualTo: akhirBulan)
        .get();

    print("Jumlah dokumen ditemukan: ${snapshot.docs.length}");

    int total = snapshot.docs.fold(0, (sum, doc) {
      print("Data dokumen: ${doc.data()}");
      return sum + (doc['total_bayar'] as int);
    });

    print("Total untuk koleksi $collection: $total");
    return total;
  }

  void fetchKeuangan() {
    FirebaseFirestore.instance
        .collection('pemasukan')
        .snapshots()
        .listen((pemasukanSnapshot) {
      FirebaseFirestore.instance
          .collection('pengeluaran')
          .snapshots()
          .listen((pengeluaranSnapshot) async {
        List<Map<String, dynamic>> pemasukan = [];

        for (var doc in pemasukanSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

          // Query nama penghuni berdasarkan id_penghuni
          var penghuniSnapshot = await FirebaseFirestore.instance
              .collection('penghuni')
              .doc(data['id_penghuni'])
              .get();

          var propertiSnapshot = await FirebaseFirestore.instance
              .collection('properti')
              .doc(data['id_properti'])
              .get();

          var kamarSnapshot = await FirebaseFirestore.instance
              .collection('kamar')
              .doc(data['id_kamar'])
              .get();

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
          var propertiSnapshot = await FirebaseFirestore.instance
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
