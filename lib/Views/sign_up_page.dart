import 'package:flutter/material.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/home_page.dart';
import 'package:otobix/Controllers/sign_up_controller.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildWelcomeText(),
            SizedBox(height: 20),
            _buildRoleSelection(),
            SizedBox(height: 20),
            _buildTextField(
              title: 'Contact Number',
              hintText: 'Enter your contact number',
              icon: Icons.phone,
            ),
            SizedBox(height: 20),
            _buildRegisterButton(context),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(onPressed: () {}, child: Text('Login')),
              ],
            ),
          ],
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
        'Select Role',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      SizedBox(height: 5),
      Row(
        children: [
          GetBuilder<SignUpController>(
            builder:
                (controller) => InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.person),
                        SizedBox(height: 5),
                        const Text('Customer', style: TextStyle()),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    ],
  );

  //Register Button
  Widget _buildRegisterButton(BuildContext context) => InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    },
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('Sign Up', style: TextStyle(color: AppColors.white)),
    ),
  );

  //Text Field
  Widget _buildTextField({
    required String title,
    required String hintText,
    required IconData icon,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: Icon(icon),
          hintText: hintText,
        ),
      ),
      SizedBox(height: 15),
    ],
  );
}
