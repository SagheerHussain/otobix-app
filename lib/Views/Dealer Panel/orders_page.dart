import 'package:flutter/material.dart';
import 'package:otobix/Views/Dealer%20Panel/in_negotiation_page.dart';
import 'package:otobix/Views/Dealer%20Panel/procured_page.dart';
import 'package:otobix/Views/Dealer%20Panel/rc_transfer_page.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';
import 'package:otobix/Utils/app_colors.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

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
                titles: ['In Negotiation', 'Procured', 'RC Transfer'],
                counts: [3, 2, 5],
                screens: [
                  InNegotiationPage(),
                  ProcuredPage(),
                  RCTransferPage(),
                ],
                titleSize: 9,
                countSize: 7,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextFormField(
          // controller: getxController.searchController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 12),
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
      ),
    );
  }
}
