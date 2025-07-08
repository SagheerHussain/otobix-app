import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/sign_up_page.dart';
import 'package:otobix/Views/sing_up_form_page.dart';

void main() {
  Get.config(enableLog: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
      ),
      home: SignUpPage(),
      // home: SingUpFormPage(),
    );
  }
}
