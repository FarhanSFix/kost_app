import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/routes/app_pages.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/KOST.png',
                    width: 74,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hallo,',
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.getJumlahStatusPembayaranBulanIni();
                      AwesomeDialog(
                        dialogBackgroundColor: Colors.white,
                        context: context,
                        dialogType: controller.isSemuaLunas.value
                            ? DialogType.success
                            : DialogType.warning,
                        animType: AnimType.rightSlide,
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Status Pembayaran Bulan Ini',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                color: Colors.redAccent[100],
                                elevation: 3,
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    expansionTileTheme:
                                        const ExpansionTileThemeData(
                                      backgroundColor: Colors.transparent,
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded:
                                        Get.arguments == 'Belum Bayar',
                                    iconColor: Colors.black,
                                    visualDensity: VisualDensity.compact,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    expandedAlignment: Alignment.centerLeft,
                                    maintainState: true,
                                    title: Obx(() => Text(
                                        'Belum Bayar (${controller.totalBelumBayar} orang)')),
                                    children: [
                                      // Kontainer Berwarna Putih untuk Menutupi Area Bawah
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: Obx(
                                            () {
                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap:
                                                    true, // Sesuaikan tinggi dengan konten
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // Nonaktifkan scroll tambahan
                                                itemBuilder: (context, index) {
                                                  return Text(
                                                    '${index + 1}. ${controller.belumBayar[index]}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 8),
                                                itemCount: controller
                                                    .totalBelumBayar.value,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                color: Colors.yellow[400],
                                elevation: 3,
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    expansionTileTheme:
                                        const ExpansionTileThemeData(
                                      backgroundColor: Colors.transparent,
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded:
                                        Get.arguments == 'Belum Lunas',
                                    iconColor: Colors.black,
                                    visualDensity: VisualDensity.compact,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    expandedAlignment: Alignment.centerLeft,
                                    maintainState: true,
                                    title: Obx(() => Text(
                                        'Belum Lunas (${controller.totalBelumLunas} orang)')),
                                    children: [
                                      // Kontainer Berwarna Putih untuk Menutupi Area Bawah
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: Obx(
                                            () {
                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap:
                                                    true, // Sesuaikan tinggi dengan konten
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // Nonaktifkan scroll tambahan
                                                itemBuilder: (context, index) {
                                                  return Text(
                                                    '${index + 1}. ${controller.belumLunas[index]}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 8),
                                                itemCount: controller
                                                    .totalBelumLunas.value,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                color: Colors.green[300],
                                elevation: 3,
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    expansionTileTheme:
                                        const ExpansionTileThemeData(
                                      backgroundColor: Colors.transparent,
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                    ),
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: Get.arguments == 'Lunas',
                                    iconColor: Colors.black,
                                    visualDensity: VisualDensity.compact,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    expandedAlignment: Alignment.centerLeft,
                                    maintainState: true,
                                    title: Obx(() => Text(
                                        'Lunas (${controller.totalLunas} orang)')),
                                    children: [
                                      // Kontainer Berwarna Putih untuk Menutupi Area Bawah
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          child: Obx(
                                            () {
                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap:
                                                    true, // Sesuaikan tinggi dengan konten
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // Nonaktifkan scroll tambahan
                                                itemBuilder: (context, index) {
                                                  return Text(
                                                    '${index + 1}. ${controller.lunas[index]}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 8),
                                                itemCount:
                                                    controller.totalLunas.value,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                controller.isSemuaLunas.value
                                    ? 'Yeay! Semua penghuni sudah membayar.'
                                    : 'Ayo, segera ingatkan pembayaran!',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Tutup',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            appColor.buttonTextColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Lihat Keuangan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ).show();
                    },
                    highlightColor: Colors.transparent,
                    icon:
                        const Icon(Icons.notifications_none_rounded, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: appColor.backgroundColor1,
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
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  // childAspectRatio: 0.9,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DashboardMenu(
                      'Penghuni',
                      'assets/images/img_penghuni.png',
                      onTap: () {
                        // Get.toNamed(Routes.RESIDENT);
                      },
                    ),
                    DashboardMenu(
                      'Properti',
                      'assets/images/img_properti.png',
                      onTap: () {
                        Get.toNamed(Routes.PROPERTY);
                      },
                    ),
                    DashboardMenu(
                      'Keuangan',
                      'assets/images/img_keuangan.png',
                      onTap: () {
                        // Get.toNamed(Routes.ADDFINANCE);
                      },
                    ),
                    DashboardMenu(
                      'Kejadian',
                      'assets/images/img_kejadian.png',
                      onTap: () {
                        // Get.toNamed(Routes.EVENT);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Statistik Keuangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.indexStatistik.value = 0;
                            },
                            child: Container(
                              width: 88,
                              height: 34,
                              decoration: BoxDecoration(
                                color: controller.indexStatistik.value == 0
                                    ? appColor.buttonColorPrimary
                                    : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: appColor.buttonColorPrimary,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Bulan ini',
                                  style: TextStyle(
                                    color: controller.indexStatistik.value == 0
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.indexStatistik.value = 1;
                            },
                            child: Obx(
                              () => Container(
                                width: 88,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: controller.indexStatistik.value == 1
                                      ? appColor.buttonColorPrimary
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: appColor.buttonColorPrimary,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Bulan lalu',
                                    style: TextStyle(
                                      color:
                                          controller.indexStatistik.value == 1
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Selisih'),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.indexStatistik.value == 0
                              ? controller
                                  .formatNominal(controller.selisihBulanIni)
                              : controller
                                  .formatNominal(controller.selisihBulanLalu),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFD9D9D9),
                        thickness: 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 15,
                                    color: appColor.income,
                                  ),
                                  Text('Pemasukan',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Obx(
                                () => Text(
                                  controller.indexStatistik.value == 0
                                      ? controller.formatNominal(
                                          controller.pemasukanBulanIni.value)
                                      : controller.formatNominal(
                                          controller.pemasukanBulanLalu.value),
                                  style: const TextStyle(
                                    color: appColor.income,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 1,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 15,
                                    color: appColor.outcome,
                                  ),
                                  Text('Pengeluaran',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Obx(
                                () => Text(
                                  controller.indexStatistik.value == 0
                                      ? controller.formatNominal(
                                          controller.pengeluaranBulanIni.value)
                                      : controller.formatNominal(controller
                                          .pengeluaranBulanLalu.value),
                                  style: const TextStyle(
                                    color: appColor.outcome,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Keuangan Terbaru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      // Get.toNamed(Routes.FINANCE);
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: appColor.buttonTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.keuanganList.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Tidak ada data',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.keuanganList.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.keuanganList[index];

                    return Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Dibuat ${controller.formatTanggal(item['created_at'].toDate())}',
                                        style: const TextStyle(fontSize: 10)),
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
                                        const SizedBox(width: 18),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['judul'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              item['properti'] != '-'
                                                  ? Text(
                                                      item['properti'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              item['kamar'] != null
                                                  ? Text(
                                                      'Kamar ${item['kamar']}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              item['kategori'] != null
                                                  ? Text(
                                                      item['kategori'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              item['status'] != null
                                                  ? Text(
                                                      item['status'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  : const SizedBox(),
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
                                              item['jenis'] == 'pemasukan'
                                                  ? controller.formatNominal(
                                                      item['status'] == 'Lunas'
                                                          ? item['total_bayar']
                                                          : item['uang_muka'])
                                                  : '-${controller.formatNominal(item['total_bayar'])}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    item['jenis'] == 'pemasukan'
                                                        ? appColor.income
                                                        : appColor.outcome,
                                              ),
                                            ),
                                            item['tanggal'] != null
                                                ? Text(
                                                    controller.formatTanggal(
                                                        item['tanggal']
                                                            .toDate()),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            item['periode']?['mulai'] != null
                                                ? Text(
                                                    controller.formatTanggal(
                                                        item['periode']['mulai']
                                                            .toDate()),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            item['periode']?['sampai'] != null
                                                ? Text(
                                                    '- ${controller.formatTanggal(item['periode']['sampai'].toDate())}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {},
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
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          // Tombol hapus
                                          ElevatedButton(
                                            onPressed: () {
                                              if (item['jenis'] ==
                                                  'pemasukan') {
                                                controller.deletePemasukan(
                                                    item['id'],
                                                    item['id_kamar']);
                                              } else {
                                                controller.deletePengeluaran(
                                                    item['id']);
                                              }
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
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          item['status'] == 'Belum Lunas'
                              ? ElevatedButton(
                                  onPressed: () {
                                    controller.lunasi(
                                        item['id'], item['judul']);
                                  },
                                  child: Text(
                                    'Tandai Lunas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    backgroundColor:
                                        appColor.buttonColorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ))
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardMenu extends StatelessWidget {
  final String title;
  final String image;
  final Function()? onTap;

  const DashboardMenu(this.title, this.image, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 84,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
