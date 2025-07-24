import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/bottom_navigation_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:otobix/Views/Dealer%20Panel/home_page.dart';
import 'package:otobix/Views/Dealer%20Panel/my_cars_page.dart';
import 'package:otobix/Views/Dealer%20Panel/orders_page.dart';
import 'package:otobix/Views/Dealer%20Panel/add_ons_page.dart';
import 'package:otobix/Views/Dealer%20Panel/account_page.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({super.key});

  final BottomNavigationController getxController = Get.put(
    BottomNavigationController(),
  );

  // final RxInt currentIndex = 0.obs;
  // final List<Widget> pages = [
  //   HomePage(),
  //   MyCarsPage(),
  //   OrdersPage(),
  //   AddOnsPage(),
  //   AccountPage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => getxController.pages[getxController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          currentIndex: getxController.currentIndex.value,
          onTap: (index) {
            getxController.currentIndex.value = index;
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text("Home"),
              selectedColor: AppColors.green,
            ),

            /// My Cars
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.car),
              title: Text("My Cars"),
              selectedColor: AppColors.blue,
            ),

            /// Orders
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.shopping_cart),
              title: Text("Orders"),
              selectedColor: AppColors.red,
            ),

            /// Add Ons
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.add),
              title: Text("Add Ons"),
              selectedColor: AppColors.yellow,
            ),

            /// Account
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text("Account"),
              selectedColor: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
