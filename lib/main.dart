import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';

import 'package:otobix/Views/Customer%20Panel/customer_homepage.dart';
import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
import 'package:otobix/Views/Dealer%20Panel/user_preferences_page.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/Views/Register/register_page.dart';
import 'package:otobix/Views/Register/registration_form_page.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';

import 'package:otobix/Views/splash/splash_screen.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

void main() async {
  Get.config(enableLog: false);
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        canvasColor: AppColors.white,
        dialogTheme: const DialogTheme(backgroundColor: AppColors.white),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.white,
          brightness: Brightness.light,
        ),
      ),

      home: SplashScreen(),
    );
  }
}



  // home: CarDetailsPage(
      //   car: CarModel(
      //      imageUrl: AppImages.hyundaiCreta1,
          // name: 'Hyundai Creta',
          // price: 1600000,
          // year: 2022,
          // kmDriven: 8000,
          // fuelType: 'Diesel',
          // location: 'Bengaluru',
          // isInspected: true,
          // imageUrls: [
          //   AppImages.hyundaiCreta1,
          //   AppImages.hyundaiCreta2,
          //   AppImages.hyundaiCreta3,
          // ],
      //   ),
      // type: 'live_bids',
      // ),