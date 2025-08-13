import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Utils/app_urls.dart';

import 'package:otobix/Views/Customer%20Panel/customer_homepage.dart';
import 'package:otobix/Views/Dealer%20Panel/account_page.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_approved_users_list_page.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_rejected_users_list_page.dart';
import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
import 'package:otobix/Views/Dealer%20Panel/user_preferences_page.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/Views/Register/register_page.dart';
import 'package:otobix/Views/Register/registration_form_page.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';
import 'package:otobix/Views/Sales%20Manager%20Panel/sales_manager_homepage.dart';
import 'package:otobix/Views/rough_work.dart';

import 'package:otobix/Views/splash/splash_screen.dart';
import 'package:otobix/Widgets/offline_banner_widget.dart';
import 'package:otobix/admin/admin_approved_rejected_users_page.dart';
import 'package:otobix/admin/admin_dashboard.dart';
import 'package:otobix/admin/admin_home.dart';
import 'package:otobix/helpers/Preferences_helper.dart';
import 'package:otobix/Utils/app_bindings.dart';
import 'package:otobix/Network/connectivity_service.dart';

void main() async {
  Get.config(enableLog: false);
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();
  // Initialize socket connection globally
  SocketService.instance.initSocket(AppUrls.socketBaseUrl);
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialBinding: AppBindings(),
      theme: ThemeData(
        brightness: Brightness.light,
        // fontFamily: 'Poppins',
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
      // home: CarDetailsPage(
      //   carId: '68821747968635d593293346',
      //   car: CarModel(
      //     imageUrl: AppImages.hyundaiCreta1,
      //     name: 'Hyundai Creta',
      //     price: 1600000,
      //     year: 2022,
      //     kmDriven: 8000,
      //     fuelType: 'Diesel',
      //     location: 'Bengaluru',
      //     isInspected: true,
      //     imageUrls: [
      //       AppImages.hyundaiCreta1,

      //       AppImages.hyundaiCreta2,
      //       AppImages.hyundaiCreta3,
      //     ],
      //   ),
      //   type: 'live_bids',
      // ),
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