import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/pin_code_fields_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Views/sing_up_form_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFieldsPage extends StatelessWidget {
  final String phoneNumber;

  PinCodeFieldsPage({super.key, required this.phoneNumber});

  final PinCodeFieldsController pinCodeFieldsController = Get.put(
    PinCodeFieldsController(),
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
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),

      SizedBox(height: 8),
      Text(
        phoneNumber,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
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
    cursorColor: Colors.green,
    textStyle: TextStyle(fontSize: 20, color: Colors.black),
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(8),
      fieldHeight: 50,
      fieldWidth: 40,
      activeFillColor: Colors.green.withValues(alpha: 0.2),
      inactiveFillColor: Colors.white,
      selectedFillColor: Colors.green.withValues(alpha: 0.1),
      activeColor: Colors.green,
      inactiveColor: Colors.grey,
      selectedColor: Colors.green,
    ),
    animationDuration: Duration(milliseconds: 300),
    enableActiveFill: true,
    onCompleted: (value) {
      ToastWidget.show(
        context: parentContext,
        message: "OTP Verified Successfully",
        type: ToastType.success,
      );
      Get.to(() => SingUpFormPage());

      // pinCodeFieldsController.verifyOtp(
      //   phoneNumber: phoneNumber,
      //   otp: value,
      // );
    },
    onChanged: (value) {},
  );
}
