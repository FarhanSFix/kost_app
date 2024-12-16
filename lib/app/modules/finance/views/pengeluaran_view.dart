import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/finance_controller.dart';

class PengeluaranView extends GetView {
  final FinanceC = Get.put(FinanceController());
  PengeluaranView({super.key});
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
                    if (!FinanceC.tahunList2.contains(tahun)) {
                      FinanceC.selectedTahun.value = "Semua";
                      //ada bug
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
                          FinanceC.fetchPengluaran(); // Refresh data
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
                      items: FinanceC.tahunList2
                          .map((tahun) => DropdownMenuItem<String>(
                                value: tahun,
                                child: Text(tahun),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          FinanceC.selectedTahun.value = value;
                          FinanceC.fetchPengluaran(); // Refresh data
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
                      final total = FinanceC.pengeluaranList.fold<int>(
                        0,
                        (sum, item) => sum + item.totalBayar,
                      );
                      return Text(
                        "- Rp  ${FinanceC.formatNominal(total)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appColor.outcome),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          color: appColor.outcome,
                        ),
                        Text(
                          'Total Keluar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appColor.outcome),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (FinanceC.pengeluaranList.isEmpty) {
                  return Center(child: Text("Tidak ada data"));
                }
                return ListView.builder(
                  itemCount: FinanceC.pengeluaranList.length,
                  itemBuilder: (context, index) {
                    final pengeluaran = FinanceC.pengeluaranList[index];
                    final properti = FinanceC.propertiList.firstWhereOrNull(
                      (p) => p.id == pengeluaran.idproperti,
                    );

                    // print(penghuni?.nama);
                    // print(properti?.nama);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_PENGELUARAN,
                              arguments: pengeluaran.id);
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
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'Dibuat ${FinanceC.formatTanggal(pengeluaran.dibuat)}',
                                        style: const TextStyle(fontSize: 10)),
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
                                              pengeluaran.judul ?? '-',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              properti?.nama ?? '-',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              '${pengeluaran.kategori ?? '-'}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
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
                                            '- Rp ${FinanceC.formatNominal(pengeluaran.totalBayar)}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: appColor.outcome),
                                          ),
                                          Text(
                                            FinanceC.formatTanggal(
                                                pengeluaran.tanggal),
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
                                      Get.toNamed(Routes.EDIT_PENGELUARAN,
                                          arguments: pengeluaran.id);
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
                                          color: Colors.black54, // Warna teks
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
                                                  color:
                                                      appColor.buttonTextColor),
                                            ),
                                          ),
                                          // Tombol hapus
                                          ElevatedButton(
                                            onPressed: () {
                                              FinanceC.deletePengeluaran(
                                                  pengeluaran.id);
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
                                                    const EdgeInsets.all(10),
                                                borderRadius: 10,
                                                duration:
                                                    const Duration(seconds: 2),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .red, // Warna tombol hapus
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                                vertical: 10), // Padding konten
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
          Get.toNamed(Routes.ADD_FINANCE,
              arguments: FinanceC.currentIndex.value = 1);
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: appColor.buttonColorPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
