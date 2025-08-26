import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';
import 'package:otobix/admin/admin_live_cars_list_page.dart';
import 'package:otobix/admin/admin_oto_buy_cars_list_page.dart';
import 'package:otobix/admin/admin_upcoming_cars_list_page.dart';
import 'package:otobix/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix/admin/controller/admin_live_cars_list_controller.dart';
import 'package:otobix/admin/controller/admin_oto_buy_cars_list_controller.dart';
import 'package:otobix/admin/controller/admin_upcoming_cars_list_controller.dart';

class AdminCarsListPage extends StatelessWidget {
  AdminCarsListPage({super.key});

  final AdminCarsListController mainController = Get.put(
    AdminCarsListController(),
  );
  final AdminUpcomingCarsListController upcomingController = Get.put(
    AdminUpcomingCarsListController(),
  );
  final AdminLiveCarsListController liveController = Get.put(
    AdminLiveCarsListController(),
  );
  final AdminOtoBuyCarsListController otoBuyController = Get.put(
    AdminOtoBuyCarsListController(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(children: [Flexible(child: _buildSearchBar(context))]),
            ),
            SizedBox(height: 20),
            Obx(
              () => Expanded(
                child: TabBarWidget(
                  titles: ['Upcoming', 'Live', 'OtoBuy'],
                  counts: [
                    upcomingController.upcomingCarsCount.value,
                    liveController.liveCarsCount.value,
                    otoBuyController.otoBuyCarsCount.value,
                  ],
                  screens: [
                    AdminUpcomingCarsListPage(),
                    AdminLiveCarsListPage(),
                    AdminOtoBuyCarsListPage(),
                  ],
                  titleSize: 10,
                  countSize: 8,
                  spaceFromSides: 20,
                  tabsHeight: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: mainController.searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,

          hintText: 'Search cars...',
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha: .5),
            fontSize: 12,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
        ),
        onChanged: (value) {
          mainController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }
}
