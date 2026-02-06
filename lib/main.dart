import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Services/app_update_service.dart';
import 'package:otobix/Services/notification_sevice.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/firebase_options.dart';
import 'package:otobix/helpers/shared_prefs_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:otobix/Network/api_service.dart';

void main() async {
  final start = await init();
  runApp(MyApp(home: start));
}

class MyApp extends StatefulWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // ✅ run after first frame to ensure context exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateService.instance.checkOnLaunch(appKey: AppConstants.appKey);
    });
  }

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

      // home: RegisterPinCodePage(phoneNumber: '', userRole: '', requestId: ''),
      home: widget.home,
    );
  }
}

// Initialize important services and return first screen
Future<Widget> init() async {
  Get.config(enableLog: false);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.instance.init();

  await SharedPrefsHelper.init();

  final userId = await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey);
  if (userId != null && userId.isNotEmpty) {
    await NotificationService.instance.login(userId);
    // Save App Version On App Launch -> fire-and-forget (do NOT await)
          Future.microtask(
            () => addActivityLogSafe(
              userId: userId,
              eventDetails: 'User launched the app',
            ),
          );
  }

  // Initialize socket connection globally
  SocketService.instance.initSocket(AppUrls.socketBaseUrl);
  // // await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
  final userType = await SharedPrefsHelper.getString(
    SharedPrefsHelper.userTypeKey,
  );

   

  Widget start;

  if (token != null && token.isNotEmpty) {
    // if (userType == AppConstants.roles.admin) {
    //   start = AdminDashboard();
    // } else {
    if (userType == AppConstants.roles.dealer) {
      start = BottomNavigationPage();
    } else {
      start = LoginPage();
    }
    // }
  } else {
    start = LoginPage();
  }

  return start;
}



  // Get app version
  Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      // info.version => "1.0.7"
      // info.buildNumber => "12"
      return '${info.version}(${info.buildNumber})';
    } catch (e) {
      debugPrint('Failed to get app version: $e');
      return '';
    }
  }

  // Add activity log
  Future<void> addActivityLogSafe({
    required String userId,
    required String eventDetails,
  }) async {
    try {
      if (userId.isEmpty) return;

      final appVersion = await _getAppVersion();

      final requestBody = {
        'userId': userId,
        'event': AppConstants.activityLogEvents.appLaunched,
        'eventDetails': eventDetails,
        'appVersion': appVersion,
      };

      final response = await ApiService.post(
        endpoint: AppUrls.saveAppVersionOnAppLaunch,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        debugPrint("Activity log added");
      } else {
        debugPrint(
          "Activity log failed: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      // ✅ swallow errors so it never affects login
      debugPrint("Activity log error: $e");
    }
  }