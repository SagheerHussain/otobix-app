import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/bottom_navigation_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Dealer%20Panel/account_page.dart';
import 'package:otobix/admin/admin_home.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  final BottomNavigationController getxController = Get.put(
    BottomNavigationController(),
  );

  final List<Widget> pages = [
    AdminHome(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Obx(() => pages[getxController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
          currentIndex: getxController.currentIndex.value,
          onTap: (index) {
            getxController.currentIndex.value = index;
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text("Home"),
              selectedColor: AppColors.green,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text("Profile"),
              selectedColor: AppColors.blue,
            ),           
          ],
        ),
      ),
    );
  }
}
