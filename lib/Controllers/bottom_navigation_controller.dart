import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Views/Account%20Tab/account_page.dart';
import 'package:otobix/Views/Add%20Ons%20Tab/add_ons_page.dart';
import 'package:otobix/Views/Home%20Tab/Home/home_page.dart';
import 'package:otobix/Views/My%20Cars%20Tab/my_cars_page.dart';
import 'package:otobix/Views/Orders%20Tab/orders_page.dart';

class BottomNavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    HomePage(),
    MyCarsPage(),
    OrdersPage(),
    AddOnsPage(),
    AccountPage(),
  ];
}
