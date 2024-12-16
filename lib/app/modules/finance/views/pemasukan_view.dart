import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/finance_controller.dart';

class PemasukanView extends GetView {
  final FinanceC = Get.put(FinanceController());
  PemasukanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final bulan = FinanceC.selectedBulan.value;
                    final tahun = FinanceC.selectedTahun.value;

                    // Validasi bulan dan tahun
                    if (!FinanceC.bulanList.contains(bulan)) {
                      FinanceC.selectedBulan.value = "Semua";
                    }
                    if (!FinanceC.tahunList.contains(tahun)) {
                      FinanceC.selectedTahun.value = "Semua";
                    }
                    return DropdownButton<String>(
                      value: FinanceC.selectedBulan.value,
                      items: FinanceC.bulanList
                          .map((bulan) => DropdownMenuItem<String>(
                                value: bulan,
                                child: Text(bulan),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          FinanceC.selectedBulan.value = value;
                          FinanceC.fetchPemasukan(); // Refresh data
                        }
                      },
                    );
                  }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(() {
                    return DropdownButton<String>(
                      value: FinanceC.selectedTahun.value,
                      items: FinanceC.tahunList
                          .map((tahun) => DropdownMenuItem<String>(
                                value: tahun,
                                child: Text(tahun),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          FinanceC.selectedTahun.value = value;
                          FinanceC.fetchPemasukan(); // Refresh data
                        }
                      },
                    );
                  }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(() {
                    if (FinanceC.selectedBulan.value != 'Semua' ||
                        FinanceC.selectedTahun.value != 'Semua') {
                      final total = FinanceC.pemasukanList.fold<int>(
                        0,
                        (sum, item) {
                          if (item.status == "Lunas") {
                            return sum +
                                item.totalBayar; // Tambahkan totalBayar jika lunas
                          } else {
                            return sum +
                                item.uangMuka; // Tambahkan uangMuka jika belum lunas
                          }
                        },
                      );
                      return Text(
                        "Rp  ${FinanceC.formatNominal(total)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appColor.income,
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          color: appColor.income,
                        ),
                        Text(
                          'Total Masuk',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appColor.income),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (FinanceC.penghuniList.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else if (FinanceC.pemasukanList.isEmpty ||
                    FinanceC.propertiList.isEmpty ||
                    FinanceC.kamarList.isEmpty) {
                  return Center(child: Text("Tidak ada data"));
                }
                return ListView.builder(
                  itemCount: FinanceC.pemasukanList.length,
                  itemBuilder: (context, index) {
                    final pemasukan = FinanceC.pemasukanList[index];
                    final penghuni = FinanceC.penghuniList.firstWhereOrNull(
                      (p) => p.id == pemasukan.idPenghuni,
                    );
                    final properti = FinanceC.propertiList.firstWhereOrNull(
                      (p) => p.id == pemasukan.idProperti,
                    );
                    final kamar = FinanceC.kamarList.firstWhereOrNull(
                      (p) => p.id == pemasukan.idKamar,
                    );
                    var statusValue = pemasukan.status.obs;
                    print(penghuni?.nama);
                    print(kamar?.nomor);
                    // print(properti?.nama);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_PEMASUKAN,
                              arguments: pemasukan.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'Dibuat ${FinanceC.formatTanggal(pemasukan.dibuat)}',
                                            style:
                                                const TextStyle(fontSize: 10)),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 62,
                                            height: 62,
                                            decoration: const BoxDecoration(
                                              color: appColor.backgroundColor2,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                color: appColor.logoColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 18,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  penghuni?.nama ?? '-',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  properti?.nama ?? '-',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'kamar ${kamar?.nomor ?? '-'}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  pemasukan.status,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                pemasukan.status == 'Lunas'
                                                    ? 'Rp ${FinanceC.formatNominal(pemasukan.totalBayar)}'
                                                    : 'Rp ${FinanceC.formatNominal(pemasukan.uangMuka)}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: appColor.income),
                                              ),
                                              Text(
                                                pemasukan.periode['mulai'] !=
                                                        null
                                                    ? FinanceC.formatTanggal(
                                                        (pemasukan.periode[
                                                                    'mulai']
                                                                as Timestamp)
                                                            .toDate(),
                                                      )
                                                    : '-',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                pemasukan.periode['sampai'] !=
                                                        null
                                                    ? FinanceC.formatTanggal(
                                                        (pemasukan.periode[
                                                                    'sampai']
                                                                as Timestamp)
                                                            .toDate(),
                                                      )
                                                    : '-',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.toNamed(Routes.EDIT_PEMASUKAN,
                                              arguments: pemasukan.id);
                                        },
                                        padding: EdgeInsets.zero,
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        constraints: const BoxConstraints(),
                                        style: const ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // the '2023' part
                                        ),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          color: appColor.buttonColorEdit,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 45),
                                      IconButton(
                                        onPressed: () {
                                          FinanceC.deletePemasukan(
                                              pemasukan.id, kamar?.id ?? '');
                                          Get.defaultDialog(
                                            title: 'Hapus Data',
                                            titleStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .red, // Ganti warna judul dialog
                                            ),
                                            middleText:
                                                'Apakah Anda yakin ingin menghapus data ini?',
                                            middleTextStyle: const TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.black54, // Warna teks
                                            ),
                                            backgroundColor: Colors
                                                .white, // Warna latar belakang dialog
                                            radius: 10, // Radius sudut dialog
                                            barrierDismissible:
                                                false, // Mencegah menutup dialog dengan menekan luar dialog
                                            actions: [
                                              // Tombol batal
                                              TextButton(
                                                onPressed: () {
                                                  Get.back(); // Menutup dialog
                                                },
                                                child: const Text(
                                                  'Batal',
                                                  style: TextStyle(
                                                      color: appColor
                                                          .buttonTextColor),
                                                ),
                                              ),
                                              // Tombol hapus
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Aksi hapus data
                                                  Get.back(); // Menutup dialog setelah menghapus data
                                                  Get.snackbar(
                                                    'Sukses',
                                                    'Data berhasil dihapus',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            185, 76, 175, 79),
                                                    colorText: Colors.white,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    borderRadius: 10,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Warna tombol hapus
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            titlePadding: const EdgeInsets.all(
                                                20), // Padding judul
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical:
                                                        10), // Padding konten
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        constraints: const BoxConstraints(),
                                        style: const ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // the '2023' part
                                        ),
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          color: appColor.buttonColorDelete,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Obx(() {
                                if (statusValue == 'Belum Lunas') {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        FinanceC.lunasi(pemasukan.id,
                                            penghuni?.nama ?? '-');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: appColor.buttonColorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 30,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1 /
                                                3.5,
                                        child: Text(
                                          'Tandai Lunas',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Lato'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              })
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_FINANCE);
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: appColor.buttonColorPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
