import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Views/Register/register_pin_code_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';

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

  Future<void> sendOTP({required String phoneNumber}) async {
    isLoading.value = true;
    try {
      final formattedPhoneNumber =
          phoneNumber.startsWith('0')
              ? '+92${phoneNumber.substring(1)}'
              : '+92$phoneNumber';

      if (selectedRole.value.isEmpty) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please select a role",
          type: ToastType.error,
        );
        return;
      }
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

    
      
        Get.to(
          () => RegisterPinCodePage(phoneNumber: formattedPhoneNumber, userType: selectedRole.value),
        );
        ToastWidget.show(
          context: Get.context!,
          message: "OTP Sent Successfully",
          type: ToastType.success,
        );
      
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        message: "Failed to send OTP",
        type: ToastType.error,
        );
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

      if (phoneNumber.length < 10) {
        ToastWidget.show(
          context: Get.context!,
          message: "Please enter a valid mobile number",
          type: ToastType.error,
        );
        return;
      }

      await Future.delayed(const Duration(seconds: 2), () {
        Get.to(() => RegisterPinCodePage(
              phoneNumber: phoneNumber,
              userType: selectedRole.value,
            ));
      });
print("OTP Sent Successfully (Dummy) $phoneNumber $selectedRole");
      ToastWidget.show(
        context: Get.context!,
        message: "OTP Sent Successfully (Dummy)",
        type: ToastType.success,
      );
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
