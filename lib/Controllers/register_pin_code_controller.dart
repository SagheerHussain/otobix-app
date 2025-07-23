import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/registration_form_controller.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Register/registration_form_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class RegisterPinCodeController extends GetxController {
  // Verify OTP
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String userType,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.verifyOtp,
        body: {"phoneNumber": phoneNumber, "otp": otp},
      );
      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "OTP Verified Successfully",
          type: ToastType.success,
        );
        Get.delete<RegistrationFormController>();
        Get.to(
          () => RegistrationFormPage(
            userRole: userType,
            phoneNumber: phoneNumber,
          ),
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
        title: "Error Verifying OTP",
        type: ToastType.error,
      );
    }
  }

  // Dummy verify OTP
  Future<void> dummyVerifyOtp({
    required String phoneNumber,
    required String otp,
    required String userType,
  }) async {
    ToastWidget.show(
      context: Get.context!,
      title: "OTP Verified Successfully",
      type: ToastType.success,
    );
    Get.delete<RegistrationFormController>();
    Get.to(
      () => RegistrationFormPage(userRole: userType, phoneNumber: phoneNumber),
    );
  }
}
