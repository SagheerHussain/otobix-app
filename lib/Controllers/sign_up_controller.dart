import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/pin_code_fields_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'dart:convert';

class SignUpController extends GetxController {
  RxString selectedRole = 'Customer'.obs;

  void setSelectedRole(String role) {
    selectedRole.value = role;
    update();
  }

  // Send OTP
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      final formattedPhoneNumber =
          phoneNumber.startsWith('0')
              ? '+92${phoneNumber.substring(1)}'
              : '+92$phoneNumber';

      //Check if role is Customer or Sales Manager
      if (selectedRole.value == 'Customer' ||
          selectedRole.value == 'Sales Manager') {
        ToastWidget.show(
          context: Get.context!,
          message: "${selectedRole.value} role is not available yet",
          type: ToastType.error,
        );
        return;
      }

      //Check if phone number is valid
      if (phoneNumber.length != 10) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please enter a valid 10-digit mobile number",
          type: ToastType.error,
        );
        return;
      }

      final response = await http.post(
        Uri.parse(AppUrls.sendOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phoneNumber": formattedPhoneNumber}),
      );
      if (response.statusCode == 200) {
        Get.to(
          // () => PinCodeFieldsPage(phoneNumber: "+91${phoneController.text}"),
          () => PinCodeFieldsPage(phoneNumber: formattedPhoneNumber),
        );
        ToastWidget.show(
          context: Get.context!,
          message: "OTP Sent Successfully",
          type: ToastType.success,
        );
      } else {
        debugPrint(response.body);
        ToastWidget.show(
          context: Get.context!,
          message: "Failed to send OTP",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        message: "Failed to send OTP",
        type: ToastType.error,
      );
    }
  }
}
