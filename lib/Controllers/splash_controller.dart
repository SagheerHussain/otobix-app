import 'package:get/get.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
import 'package:otobix/admin/admin_home.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

class SplashController extends GetxController {
  String? token;
  String? userType;

  @override
  void onInit() {
    super.onInit();
    checkToken();
  }

  void checkToken() async {
    token = await SharedPrefsHelper.getString("token");
    userType = await SharedPrefsHelper.getString("userType");

    print("token: $token");
    print("userType: $userType");

    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        if (userType == 'admin') {
          Get.off(() => AdminHome());
        } else {
          Get.off(() => BottomNavigationPage());
        }
      } else {
        Get.off(() => LoginPage());
      }
    });
  }
}
