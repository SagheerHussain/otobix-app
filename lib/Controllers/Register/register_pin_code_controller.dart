import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Register/registration_form_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPinCodeController extends GetxController {
  // Send OTP
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrls.verifyOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phoneNumber": phoneNumber, "otp": otp}),
      );
      if (response.statusCode == 200) {
        Get.to(() => RegistrationFormPage());
        ToastWidget.show(
          context: Get.context!,
          message: "OTP Verified Successfully",
          type: ToastType.success,
        );
      } else {
        debugPrint(response.body);
        ToastWidget.show(
          context: Get.context!,
          message: "Invalid OTP",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        message: "Invalid OTP",
        type: ToastType.error,
      );
    }
  }
}
