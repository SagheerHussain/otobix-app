import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Views/Login/login_pin_code_page.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecureText = false.obs;

  dummySendOtp(String phoneNumber) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2), () {
        Get.to(() => LoginPinCodePage(phoneNumber: phoneNumber));
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password is required.";
    }

    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter.";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return "Password must contain at least one special character.";
    }

    return null; // Valid
  }
}
