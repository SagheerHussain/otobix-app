import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Customer%20Panel/customer_homepage.dart';
import 'package:otobix/Views/Register/register_page.dart';
import 'package:otobix/Views/splash/splash_screen.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

void main() {
  Get.config(enableLog: false);
  SharedPrefsHelper.init();
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

      home: RegisterPage(),
    );
  }
}


  // home: CarDetailsPage(
      //   car: CarModel(
      //     imageUrl:
      //         'https://imgcdn.oto.com/large/gallery/exterior/15/1968/hyundai-creta-front-cross-side-view-356951.jpg',
      //     name: 'Hyundai Creta',
      //     price: 1600000,
      //     year: 2022,
      //     kmDriven: 8000,
      //     fuelType: 'Diesel',
      //     location: 'Bengaluru',
      //     isInspected: true,
      //     imageUrls: [
      //       'https://imgcdn.oto.com/large/gallery/exterior/15/1968/hyundai-creta-front-cross-side-view-356951.jpg',
      //       'https://www.hyundai.com/content/dam/hyundai/in/en/data/find-a-car/Creta/Highlights/mob/cretagalleryb2.jpg',
      //       'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/2022_Hyundai_Creta_1.6_Plus_%28Chile%29_front_view.jpg/1200px-2022_Hyundai_Creta_1.6_Plus_%28Chile%29_front_view.jpg',
      //     ],
      //   ),
      // ),