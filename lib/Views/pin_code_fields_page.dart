import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/pin_code_fields_controller.dart';
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
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
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
            SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
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
                // ToastWidget.show(
                //   context: context,
                //   message: "OTP Verified Successfully",
                //   type: ToastType.success,
                // );
                // Get.to(() => const SingUpFormPage());
                pinCodeFieldsController.verifyOtp(
                  phoneNumber: phoneNumber,
                  otp: value,
                );
              },
              onChanged: (value) {},
            ),
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
      ),
    );
  }
}
