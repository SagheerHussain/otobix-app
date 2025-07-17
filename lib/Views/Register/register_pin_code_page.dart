import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/Register/register_pin_code_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterPinCodePage extends StatelessWidget {
  final String phoneNumber;
  final String userRole;

  RegisterPinCodePage({
    super.key,
    required this.phoneNumber,
    required this.userRole,
  });

  final RegisterPinCodeController pinCodeFieldsController = Get.put(
    RegisterPinCodeController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Verify Phone'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildAppLogo(),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildOtpMessageText(),
                SizedBox(height: 30),
                _buildPinCodeTextField(context),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     pinCodeFieldsController.verifyOtp(
                //       phoneNumber: phoneNumber,
                //       otp: value,
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                //   child: Text("Verify", style: TextStyle(color: Colors.white)),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // App Logo
  Widget _buildAppLogo() =>
      Image.asset(AppImages.appLogo, height: 150, width: 150);

  Widget _buildOtpMessageText() => Column(
    children: [
      Text(
        "Enter the OTP sent to",
        style: TextStyle(fontSize: 16, color: AppColors.black),
      ),

      SizedBox(height: 8),
      Text(
        '(+91) - $phoneNumber',
        style: TextStyle(
          fontSize: 18,
          color: AppColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _buildPinCodeTextField(BuildContext parentContext) => PinCodeTextField(
    appContext: parentContext,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(6),
    ],
    keyboardType: TextInputType.number,
    length: 6,
    obscureText: false,
    animationType: AnimationType.fade,
    cursorColor: AppColors.green,
    textStyle: TextStyle(fontSize: 20, color: AppColors.black),
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(8),
      fieldHeight: 50,
      fieldWidth: 40,
      activeFillColor: AppColors.green.withValues(alpha: 0.2),
      inactiveFillColor: AppColors.white,
      selectedFillColor: AppColors.green.withValues(alpha: 0.1),
      activeColor: AppColors.green,
      inactiveColor: AppColors.gray,
      selectedColor: AppColors.green,
    ),
    animationDuration: Duration(milliseconds: 300),
    enableActiveFill: true,
    onCompleted: (otpValue) {
      pinCodeFieldsController.dummyVerifyOtp(
        phoneNumber: phoneNumber,
        otp: otpValue,
        userType: userRole,
      );

      // pinCodeFieldsController.verifyOtp(
      //   phoneNumber: phoneNumber,
      //   otp: value,
      // userType: userType,
      // );
    },
    onChanged: (otpValue) {},
  );
}
