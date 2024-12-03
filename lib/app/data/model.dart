import 'dart:io';

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

  Kamar({required this.id, required this.nomor, required this.status});

  factory Kamar.fromFireStore(Map<String, dynamic> data, String id) {
    return Kamar(
      id: id,
      nomor: data['nomor'],
      status: data['status'],
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
