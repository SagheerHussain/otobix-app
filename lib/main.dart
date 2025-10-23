import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Services/notification_sevice.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/splash/splash_screen.dart';
import 'package:otobix/firebase_options.dart';
import 'package:otobix/helpers/shared_prefs_helper.dart';

void main() async {
  Get.config(enableLog: false);
  WidgetsFlutterBinding.ensureInitialized();

  // debugPrint('>>> BEFORE Firebase.init');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // debugPrint('>>> AFTER Firebase.init');

  // debugPrint('>>> BEFORE OneSignal.init');
  await NotificationService.instance.init();
  // debugPrint('>>> AFTER OneSignal.init');

  await SharedPrefsHelper.init();

  final userId = await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey);
  if (userId != null && userId.isNotEmpty) {
    await NotificationService.instance.login(userId);
  }

  // Initialize socket connection globally
  SocketService.instance.initSocket(AppUrls.socketBaseUrl);
  // // await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey:
          Get.key, // enables Get.* navigation from services (for route to specific screen via notification click)
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.white,
        canvasColor: AppColors.white,
        // dialogTheme: const DialogTheme(backgroundColor: AppColors.white),
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
