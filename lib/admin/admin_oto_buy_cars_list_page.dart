import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Widgets/empty_page_widget.dart';
import 'package:otobix/admin/controller/admin_oto_buy_cars_list_controller.dart';

class AdminOtoBuyCarsListPage extends StatelessWidget {
  AdminOtoBuyCarsListPage({super.key});

  final AdminOtoBuyCarsListController getxController =
      Get.find<AdminOtoBuyCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmptyPageWidget(
                icon: Icons.car_rental,
                title: 'OtoBuy',
                description: 'No OtoBuy Cars Found.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
