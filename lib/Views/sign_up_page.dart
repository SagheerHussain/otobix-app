import 'package:flutter/material.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/login_page.dart';
import 'package:otobix/Controllers/sign_up_controller.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final SignUpController getxController = Get.put(SignUpController());
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              _buildWelcomeText(),
              SizedBox(height: 20),
              _buildRoleSelection(),
              SizedBox(height: 20),
              _buildPhoneNumberField(context),
              SizedBox(height: 20),
              _buildContinueButton(context),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () => Get.to(() => const LoginPage()),
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Welcome Text
  Widget _buildWelcomeText() => Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Create an Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blue,
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Welcome! Please enter your details',
          style: TextStyle(fontSize: 12, color: AppColors.black),
        ),
      ),
    ],
  );

  //Role Selection
  Widget _buildRoleSelection() => Column(
    children: [
      Text(
        'Select a Role',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      SizedBox(height: 5),
      Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRoleSelectionButton(icon: Icons.person, role: 'Customer'),
          _buildRoleSelectionButton(icon: Icons.directions_car, role: 'Dealer'),
          _buildRoleSelectionButton(
            icon: Icons.admin_panel_settings,
            role: 'Sales Manager',
          ),
        ],
      ),
    ],
  );

  //Role Selection Button
  Widget _buildRoleSelectionButton({
    required IconData icon,
    required String role,
  }) => GetBuilder<SignUpController>(
    builder:
        (getxController) => InkWell(
          onTap: () => getxController.setSelectedRole(role),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color:
                  getxController.selectedRole.value == role
                      ? AppColors.green
                      : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    getxController.selectedRole.value == role
                        ? AppColors.green
                        : AppColors.black,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      getxController.selectedRole.value == role
                          ? AppColors.white
                          : AppColors.black,
                ),
                SizedBox(height: 5),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        getxController.selectedRole.value == role
                            ? AppColors.white
                            : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
  );

  //Continue Button
  Widget _buildContinueButton(BuildContext context) => InkWell(
    onTap: () => getxController.sendOTP(phoneNumber: phoneController.text),
    // onTap:
    //     () => Get.to(
    //       () => PinCodeFieldsPage(phoneNumber: "+92${phoneController.text}"),
    //     ),
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('Continue', style: TextStyle(color: AppColors.white)),
    ),
  );

  //Text Field
  // Widget _buildTextField({
  //   required String title,
  //   required String hintText,
  //   required IconData icon,
  // }) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.black,
  //       ),
  //     ),
  //     SizedBox(height: 5),
  //     TextField(
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
  //         prefixIcon: Icon(icon),
  //         hintText: hintText,
  //       ),
  //     ),
  //     SizedBox(height: 15),
  //   ],
  // );

  Widget _buildPhoneNumberField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Number',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black),
                borderRadius: BorderRadius.circular(5),
                color: AppColors.white,
              ),
              child: Text(
                '+91',
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: phoneController,

                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'e.g. 9876543210',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
