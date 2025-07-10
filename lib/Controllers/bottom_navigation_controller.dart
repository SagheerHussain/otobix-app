import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Views/Home%20Tab/Home/home_page.dart';

class BottomNavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    HomePage(),
    Center(child: Text("My Cars", style: TextStyle(fontSize: 24))),
    Center(child: Text("Orders", style: TextStyle(fontSize: 24))),
    Center(child: Text("Add Ons", style: TextStyle(fontSize: 24))),
    Center(child: Text("Account", style: TextStyle(fontSize: 24))),
  ];
}
