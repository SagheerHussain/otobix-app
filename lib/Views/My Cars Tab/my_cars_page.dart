import 'package:flutter/material.dart';
import 'package:otobix/Controllers/My%20Cars%20Tab/my_cars_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/My%20Cars%20Tab/live_bids_page.dart';
import 'package:otobix/Views/My%20Cars%20Tab/ocb_nego_page.dart';
import 'package:otobix/Views/My%20Cars%20Tab/wishlist_page.dart';
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: getxController.searchController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Search...',
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
            vertical: 3,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
