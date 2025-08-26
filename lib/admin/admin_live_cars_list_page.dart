import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Widgets/empty_page_widget.dart';
import 'package:otobix/admin/controller/admin_live_cars_list_controller.dart';

class AdminLiveCarsListPage extends StatelessWidget {
  AdminLiveCarsListPage({super.key});

  final AdminLiveCarsListController getxController =
      Get.find<AdminLiveCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmptyPageWidget(
                icon: Icons.car_rental,
                title: 'Live Cars',
                description: 'No Live Cars Found.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
