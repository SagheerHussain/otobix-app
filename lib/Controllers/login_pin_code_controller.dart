import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class LoginPinCodeController extends GetxController {
  // Send OTP
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.verifyOtp,
        body: {"phoneNumber": phoneNumber, "otp": otp},
      );

      if (response.statusCode == 200) {
        Get.to(() => BottomNavigationPage());
        ToastWidget.show(
          context: Get.context!,
          title: "OTP Verified Successfully",
          type: ToastType.success,
        );
      } else {
        debugPrint(response.body);
        ToastWidget.show(
          context: Get.context!,
          title: "Invalid OTP",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: "Invalid OTP",
        type: ToastType.error,
      );
    }
  }
}
