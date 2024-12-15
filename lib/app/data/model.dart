import 'package:cloud_firestore/cloud_firestore.dart';

class Penghuni {
  String id;
  String nama;
  String telepon;
  String idProperti;
  String idKamar;
  bool isActive;
  String foto_KTP;
  String foto_penghuni;

  Penghuni({
    required this.id,
    required this.nama,
    required this.telepon,
    required this.idProperti,
    required this.idKamar,
    required this.isActive,
    required this.foto_KTP,
    required this.foto_penghuni,
  });

  factory Penghuni.fromFirestore(Map<String, dynamic> data, String id) {
    return Penghuni(
      id: id,
      nama: data['nama'] ?? '',
      telepon: data['telepon'] ?? '',
      idProperti: data['id_properti'] ?? '',
      idKamar: data['id_kamar'] ?? '',
      isActive: data['is_active'] ?? false,
      foto_KTP: data['foto_KTP'] ?? '',
      foto_penghuni: data['foto_penghuni'] ?? '',
    );
  }
}

class Properti {
  String id;
  String nama;

  Properti({required this.id, required this.nama});

  factory Properti.fromFireStore(Map<String, dynamic> data, String id) {
    return Properti(
      id: id,
      nama: data['nama_properti'] ?? '',
    );
  }
}

class Kamar {
  String id;
  String nomor;
  String status;
  Map<String, dynamic> harga;

  Kamar(
      {required this.id,
      required this.nomor,
      required this.status,
      required this.harga});

  factory Kamar.fromFireStore(Map<String, dynamic> data, String id) {
    return Kamar(
      id: id,
      nomor: data['nomor'],
      status: data['status'],
      harga: data['harga'] ?? {},
    );
  }
}

class Kejadian {
  String id;
  String id_penghuni;
  String kejadian;
  String foto_bukti;
  int nominal;
  String status;

  Kejadian({
    required this.id,
    required this.id_penghuni,
    required this.kejadian,
    required this.foto_bukti,
    required this.nominal,
    required this.status,
  });

  factory Kejadian.fromFireStore(Map<String, dynamic> data, String id) {
    return Kejadian(
        id: id,
        id_penghuni: data['id_penghuni'],
        kejadian: data['kejadian'],
        foto_bukti: data['foto_bukti'],
        nominal: data['nominal'],
        status: data['status']);
  }
}

class Pemasukan {
  String id;
  String catatan;
  DateTime dibuat;
  int denda;
  String idKamar;
  String idPenghuni;
  String idProperti;
  String jmlBulan;
  String jmlPenghuni;
  int sisa;
  String status;
  Map<String, dynamic> periode;
  int totalBayar;
  int uangMuka;

  Pemasukan({
    required this.id,
    required this.catatan,
    required this.dibuat,
    required this.denda,
    required this.idKamar,
    required this.idPenghuni,
    required this.idProperti,
    required this.jmlBulan,
    required this.jmlPenghuni,
    required this.sisa,
    required this.status,
    required this.periode,
    required this.totalBayar,
    required this.uangMuka,
  });

  factory Pemasukan.fromFireStore(Map<String, dynamic> data, String id) {
    return Pemasukan(
      id: id,
      catatan: data['catatan'] ?? '',
      dibuat: (data['created_at'] as Timestamp).toDate(),
      denda: data['denda'],
      idKamar: data['id_kamar'],
      idPenghuni: data['id_penghuni'] ?? "",
      idProperti: data['id_properti'],
      jmlBulan: data['jml_bulan'],
      jmlPenghuni: data['jml_penghuni'],
      sisa: data['sisa'],
      status: data['status'],
      periode: data['periode'] ?? {},
      totalBayar: data['total_bayar'],
      uangMuka: data['uang_muka'],
    );
  }
}

class Pengeluaran {
  String id;
  DateTime dibuat;
  String file;
  String idproperti;
  String judul;
  String kategori;
  DateTime tanggal;
  int totalBayar;

  Pengeluaran({
    required this.id,
    required this.dibuat,
    required this.file,
    required this.idproperti,
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.totalBayar,
  });

  factory Pengeluaran.fromFireStore(Map<String, dynamic> data, String id) {
    return Pengeluaran(
      id: id,
      dibuat: (data['created_at'] as Timestamp).toDate(),
      file: data['file'],
      idproperti: data['id_properti'],
      judul: data['judul'],
      kategori: data['kategori'],
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      totalBayar: data['total_bayar'],
    );
  }
}
