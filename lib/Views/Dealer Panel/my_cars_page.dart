import 'package:flutter/material.dart';
import 'package:otobix/Controllers/my_cars_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Dealer%20Panel/live_bids_page.dart';
import 'package:otobix/Views/Dealer%20Panel/ocb_nego_page.dart';
import 'package:otobix/Views/Dealer%20Panel/user_notifications_page.dart';
import 'package:otobix/Views/Dealer%20Panel/wishlist_page.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';
import 'package:get/get.dart';

class MyCarsPage extends StatelessWidget {
  MyCarsPage({super.key});

  final MyCarsController getxController = Get.put(MyCarsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            _buildSearchBar(context),
            SizedBox(height: 20),

            Expanded(
              child: TabBarWidget(
                titles: ['Live Bids', 'Ocb Nego', 'Wishlist'],
                counts: [3, 2, 5],
                screens: [LiveBidsPage(), OcbNegoPage(), WishlistPage()],
                titleSize: 10,
                countSize: 8,
                spaceFromSides: 10,
                tabsHeight: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 7),
              child: TextFormField(
                controller: getxController.searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: AppColors.grey.withValues(alpha: .5),
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.green, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() =>  UserNotificationsPage()),
            child: Badge.count(
              count: 1,
              child: Icon(
                Icons.notifications_outlined,
                size: 25,
                color: AppColors.grey,
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}
