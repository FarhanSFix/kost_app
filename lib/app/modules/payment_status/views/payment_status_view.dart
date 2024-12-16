import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payment_status_controller.dart';

class PaymentStatusView extends GetView<PaymentStatusController> {
  const PaymentStatusView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Status Pembayaran'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: [
            Card(
              color: Colors.redAccent[100],
              elevation: 3,
              child: ExpansionTile(
                initiallyExpanded: Get.arguments == 'Belum Bayar',
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
                title: Obx(() =>
                    Text('Belum Bayar (${controller.totalBelumBayar} orang)')),
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
                            shrinkWrap: true, // Sesuaikan tinggi dengan konten
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: controller.totalBelumBayar.value,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.yellow[400],
              elevation: 3,
              child: ExpansionTile(
                initiallyExpanded: Get.arguments == 'Belum Lunas',
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
                title: Obx(() =>
                    Text('Belum Lunas (${controller.totalBelumLunas} orang)')),
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
                            shrinkWrap: true, // Sesuaikan tinggi dengan konten
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: controller.totalBelumLunas.value,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.green[300],
              elevation: 3,
              child: ExpansionTile(
                controller: controller.isExpanded,
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
                title:
                    Obx(() => Text('Lunas (${controller.totalLunas} orang)')),
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
                            shrinkWrap: true, // Sesuaikan tinggi dengan konten
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: controller.totalLunas.value,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isExpanded.expand();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
