import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Register/register_pin_code_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'dart:convert';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedRole = ''.obs;

  void setSelectedRole(String role) {
    selectedRole.value = role;
    update();
  }

Future<void> register() async {
  isLoading.value = true;
  try {
    
  } catch (e) {
    debugPrint(e.toString());
    ToastWidget.show(
      context: Get.context!,
      message: "Failed to register",
      type: ToastType.error,
    );
  } finally {
    isLoading.value = false;
  }
}



  // Send OTP
  Future<void> sendOTP({required String phoneNumber}) async {
    isLoading.value = true;
    try {
      final formattedPhoneNumber =
          phoneNumber.startsWith('0')
              ? '+92${phoneNumber.substring(1)}'
              : '+92$phoneNumber';

      //Check if role is selected
      if (selectedRole.value.isEmpty) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please select a role",
          type: ToastType.error,
        );
        return;
      }

      //Check if role is Customer or Sales Manager
      if (selectedRole.value == 'Customer' ||
          selectedRole.value == 'Sales\nManager') {
        ToastWidget.show(
          context: Get.context!,
          message: "${selectedRole.value} role is not available yet",
          type: ToastType.error,
        );
        return;
      }
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
          () => RegisterPinCodePage(phoneNumber: formattedPhoneNumber),
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> dummySendOtp({required String phoneNumber}) async {
    isLoading.value = true;
    try {
      if (selectedRole.value.isEmpty) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please select a role",
          type: ToastType.error,
        );
        return;
      }

      //Check if role is Customer or Sales Manager
      if (selectedRole.value == 'Customer' ||
          selectedRole.value == 'Sales\nManager') {
        ToastWidget.show(
          context: Get.context!,
          message: "${selectedRole.value} role is not available yet",
          type: ToastType.error,
        );
        return;
      }

      if (phoneNumber.length != 10) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please enter a valid 10-digit mobile number",
          type: ToastType.error,
        );
        return;
      }
      await Future.delayed(const Duration(seconds: 2), () {
        Get.to(() => RegisterPinCodePage(phoneNumber: "+92${phoneNumber}"));
      });
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        message: "Failed to send OTP",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
