import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kost_app/app/modules/add_finance/views/addpemasukan_view.dart';
import 'package:kost_app/app/modules/add_finance/views/addpengeluaran_view.dart';
import 'package:kost_app/app/utils/colors.dart';

import '../controllers/add_finance_controller.dart';

class AddFinanceView extends GetView<AddFinanceController> {
  AddFinanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: 2,
        initialIndex: controller.currentIndex.value,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tambah Keuangan'),
            centerTitle: true,
            backgroundColor: appColor.backgroundColor1,
            elevation: 0,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 45,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            bottom: TabBar(
              onTap: (index) {
                controller.currentIndex.value = index;
              },
              padding: const EdgeInsets.symmetric(horizontal: 80),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicatorWeight: 0,
              indicator: ShapeDecoration(
                color: appColor.buttonColorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
              tabs: const [
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Pemasukan",
                      style: TextStyle(fontFamily: 'Lato', fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Pengeluaran",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Lato', fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                height: 16,
                color: appColor.backgroundColor1,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AddpemasukanView(),
                    AddpengeluaranView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
