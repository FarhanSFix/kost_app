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
                height: MediaQuery.sizeOf(context).height * 1 / 16.5,
                width: MediaQuery.sizeOf(context).width * 2 / 3.7,
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
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.sizeOf(context).height * 1 / 16.5),
              child: TabBar(
                onTap: (index) {
                  controller.currentIndex.value = index;
                },
                padding: const EdgeInsets.symmetric(horizontal: 76),
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
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 1 / 4,
                      child: Center(
                        child: Text(
                          "Pemasukan",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: MediaQuery.sizeOf(context).width *
                                0.035, // Responsif
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width *
                          1 /
                          4, // Setengah container
                      child: Center(
                        child: Text(
                          "Pengeluaran",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: MediaQuery.sizeOf(context).width *
                                0.030, // Responsif
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
