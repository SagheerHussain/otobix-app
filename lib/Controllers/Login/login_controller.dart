import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';
import 'package:otobix/Views/bottom_navigation_page.dart';
import 'package:otobix/admin/admin_home.dart';
import 'package:otobix/admin/rejected_screen.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecureText = false.obs;
  final dealerNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedEntityType;
  final Map<String, List<String>> entityDocuments = {
    'Individual': [
      'Pan Card (self attested)',
      'Adhar Card (self attested)',
      'GST (individual name, self attested)',
      'Cancelled Cheque',
    ],
    'Proprietary': [
      'Pan Card (self attested)',
      'Adhar Card (self attested)',
      'Trade license (sign & stamp)',
      'GST (sign & stamp)',
      'Cancelled Cheque',
    ],
    'Huf': [
      'Huf Deed (signed & stamped by Karta)',
      'Huf Pan (signed & stamped by Karta)',
      'Pan card of Karta (self attested)',
      'Adhar card of Karta (self attested)',
      'Huf Cancelled Cheque',
    ],
    'Partnership': [
      'Partnership Deed copy (signed & stamped by partner)',
      'Partnership pan card (signed & stamped by partner)',
      'Trade license (signed & stamped by partner)',
      'GST (signed & stamped by partner)',
      'KYC of partners (self attested)',
      'Cancelled cheque',
    ],
    'LLP': [
      'Partnership Deed copy (signed & stamped by partner)',
      'Partnership pan card (signed & stamped by partner)',
      'Trade license (signed & stamped by partner)',
      'GST (signed & stamped by partner)',
      'KYC of partners (self attested)',
      'Cancelled cheque',
    ],
    'Ltd/Private Limited': [
      'Company PAN card (Signed & stamped by authorised director)',
      'Company trade license (Signed & stamped by authorised director)',
      'Company GST (Signed & stamped by authorised director)',
      'Board resolution Original ( To be Signed & stamped by more than 50% director. In case of Ltd companies, Company secretary can sign the board resolution and authorised anyone in the organisation to sign)',
      'KYC of directors (self attested)',
      'List of Directors MCA - (Signed & stamped by authorised director)',
      'Cancelled Cheque',
    ],
    'One person Company': [
      'Company PAN card (Signed & stamped by sole director)',
      'Company trade license (Signed & stamped by sole director)',
      'Company GST (Signed & stamped by sole director)',
      'Board resolution Original (Signed & stamped by sole director)',
      'KYC of director (self attested)',
      'List of Directors MCA (Signed & stamped by sole director)',
      'Cancelled Cheque',
    ],
  };
  
 Future<void> loginUser() async {
  isLoading.value = true;

  try {
    String dealerName = dealerNameController.text.trim();
    String contactNumber = phoneNumberController.text.trim();
    final requestBody = {
      "dealerName": dealerName,
      "contactNumber": contactNumber,
      "password": passwordController.text.trim(),
    };
    print("Sending body: $requestBody");
    final response = await ApiService.post(
      endpoint: "user/login",
      body: requestBody,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      final user = data['user'];
      final userType = user['userType'];
      final approvalStatus = user['approvalStatus'];

      print("userType: $userType");
      print("token: $token");
      print("approvalStatus: $approvalStatus");

      await SharedPrefsHelper.saveString('token', token);
      await SharedPrefsHelper.saveString('user', jsonEncode(user));
      await SharedPrefsHelper.saveString('userType', userType);

      if (userType == 'admin') {
        Get.to(() => AdminHome());
      } else {
        if (approvalStatus == 'Pending') {        
 Get.to(
        () => WaitingForApprovalPage(
          documents:
              entityDocuments[selectedEntityType ?? 'Individual'] ??
              entityDocuments['Individual']!,
        ),
      );        } else if (approvalStatus == 'Approved') {
          Get.to(() => BottomNavigationPage());
        } else if (approvalStatus == 'Rejected') {
         Get.to(() => RejectedScreen(userId: user['id']));
        } else {
          Get.snackbar(
            "Unknown Status",
            "Invalid approval status. Please contact admin.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
          );
        }
      }
    } else {
      print("data: $data");
      Get.snackbar(
        "Login Failed",
        data['message'] ?? "Invalid credentials",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  } catch (e) {
    print("Error: $e");
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
    );
  } finally {
    isLoading.value = false;
  }
}

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required.";
    if (password.length < 8) return "Password must be at least 8 characters long.";
    if (!RegExp(r'[A-Z]').hasMatch(password)) return "At least one uppercase letter required.";
    if (!RegExp(r'[a-z]').hasMatch(password)) return "At least one lowercase letter required.";
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return "At least one special character required.";
    }
    return null;
  }

Future<void> logout() async {
  try {
    await ApiService.post(endpoint: "user/logout", body: {});
    await SharedPrefsHelper.remove('token');
    await SharedPrefsHelper.remove('user');
    await SharedPrefsHelper.remove('userType');

    Get.offAll(() => LoginPage());
  } catch (e) {
    print("Error: $e");
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
    );
  }
}

}
