import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Services/notification_sevice.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Customer%20Panel/customer_homepage.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';
import 'package:otobix/Views/Sales%20Manager%20Panel/sales_manager_homepage.dart';
import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/admin/admin_dashboard.dart';
import 'package:otobix/admin/rejected_screen.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    clearFields();
  }

  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      String dealerName = userNameController.text.trim();
      String contactNumber = phoneNumberController.text.trim();
      final requestBody = {
        "userName": dealerName,
        "phoneNumber": contactNumber,
        "password": passwordController.text.trim(),
      };
      // debugPrint("Sending body: $requestBody");
      final response = await ApiService.post(
        endpoint: AppUrls.login,
        body: requestBody,
      );
      final data = jsonDecode(response.body);
      debugPrint("Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final token = data['token'];
        final user = data['user'];
        final userType = user['userType'];
        final userId = user['id'];
        final approvalStatus = user['approvalStatus'];
        final entityType = user['entityType'] ?? "";
        // debugPrint("userType: $userType");
        // debugPrint("token: $token");
        // debugPrint("approvalStatus: $approvalStatus");

        // Link current userid in OneSignal to receive push notifications
        await NotificationService.instance.login(userId);

        if (approvalStatus == 'Approved') {
          await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);
        }

        debugPrint("Token saved in local: $token");
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userKey,
          jsonEncode(user),
        );
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.userTypeKey,
          userType,
        );
        await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);
        await SharedPrefsHelper.saveString(
          SharedPrefsHelper.entityTypeKey,
          entityType,
        );
        // debugPrint("userId: $userId");
        if (userType == AppConstants.roles.admin) {
          Get.to(() => AdminDashboard());
        } else {
          if (approvalStatus == 'Pending') {
            final entityType = (user['entityType'] as String?)?.trim();
            final entityDocuments = await _fetchEntityDocuments(entityType);
            Get.to(
              () => WaitingForApprovalPage(
                documents: entityDocuments,
                userRole: userType,
              ),
            );
          } else if (approvalStatus == 'Approved') {
            if (userType == AppConstants.roles.customer) {
              Get.to(() => CustomerHomepage());
            } else if (userType == AppConstants.roles.salesManager) {
              Get.to(() => SalesManagerHomepage());
            } else if (userType == AppConstants.roles.dealer) {
              Get.to(() => BottomNavigationPage());
            }
          } else if (approvalStatus == 'Rejected') {
            Get.to(() => RejectedScreen(userId: user['id']));
          } else {
            ToastWidget.show(
              context: Get.context!,
              title: "Invalid approval status. Please contact admin.",
              type: ToastType.error,
            );
          }
        }
      } else {
        debugPrint("data: $data");
        ToastWidget.show(
          context: Get.context!,
          title: data['message'] ?? "Invalid credentials",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Something went wrong. Please try again.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required.";
    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "At least one uppercase letter required.";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "At least one lowercase letter required.";
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return "At least one special character required.";
    }
    return null;
  }

  // Fetch entity documents
  Future<List<String>> _fetchEntityDocuments(String? entityType) async {
    final fallback = <String>[
      // optional: keep empty list if you don't want a fallback
      'No documents found',
    ];

    if (entityType == null || entityType.trim().isEmpty) return fallback;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getEntityDocumentsByName(
          entityName: entityType.trim(),
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        final docs = (data['documents'] ?? []) as List;
        return docs.map((e) => '$e').toList();
      }
    } catch (error) {
      // ignore and use fallback
      debugPrint("Error: $error");
    }
    return fallback;
  }

  // Future<void> logout(String userId) async {
  //   try {
  //     await ApiService.post(endpoint: AppUrls.logout(userId), body: {});
  //     await SharedPrefsHelper.remove(SharedPrefsHelper.tokenKey);
  //     await SharedPrefsHelper.remove(SharedPrefsHelper.userKey);
  //     await SharedPrefsHelper.remove(SharedPrefsHelper.userTypeKey);
  //     Get.offAll(() => LoginPage());
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //     Get.snackbar(
  //       "Error",
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.shade100,
  //     );
  //   }
  // }

  // Clear fields
  void clearFields() {
    userNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    obsecureText.value = true;
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix/Models/user_model.dart';
// import 'package:otobix/Network/api_service.dart';
// import 'package:otobix/Utils/app_urls.dart';
// import 'package:otobix/Views/Customer%20Panel/customer_homepage.dart';
// import 'package:otobix/Views/Login/login_page.dart';
// import 'package:otobix/Views/Register/waiting_for_approval_page.dart';
// import 'package:otobix/Views/Sales%20Manager%20Panel/sales_manager_homepage.dart';
// import 'package:otobix/Views/Dealer%20Panel/bottom_navigation_page.dart';
// import 'package:otobix/Widgets/toast_widget.dart';
// import 'package:otobix/admin/admin_dashboard.dart';
// import 'package:otobix/admin/rejected_screen.dart';
// import 'package:otobix/helpers/Preferences_helper.dart';

// class LoginController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     clearFields();
//   }

//   RxBool isLoading = false.obs;
//   RxBool obsecureText = true.obs;
//   final userNameController = TextEditingController();
//   final phoneNumberController = TextEditingController();
//   final passwordController = TextEditingController();
//   String? selectedEntityType;
//   final Map<String, List<String>> entityDocuments = {
//     'Individual': [
//       'Pan Card (self attested)',
//       'Adhar Card (self attested)',
//       'GST (individual name, self attested)',
//       'Cancelled Cheque',
//     ],
//     'Proprietary': [
//       'Pan Card (self attested)',
//       'Adhar Card (self attested)',
//       'Trade license (sign & stamp)',
//       'GST (sign & stamp)',
//       'Cancelled Cheque',
//     ],
//     'Huf': [
//       'Huf Deed (signed & stamped by Karta)',
//       'Huf Pan (signed & stamped by Karta)',
//       'Pan card of Karta (self attested)',
//       'Adhar card of Karta (self attested)',
//       'Huf Cancelled Cheque',
//     ],
//     'Partnership': [
//       'Partnership Deed copy (signed & stamped by partner)',
//       'Partnership pan card (signed & stamped by partner)',
//       'Trade license (signed & stamped by partner)',
//       'GST (signed & stamped by partner)',
//       'KYC of partners (self attested)',
//       'Cancelled cheque',
//     ],
//     'LLP': [
//       'Partnership Deed copy (signed & stamped by partner)',
//       'Partnership pan card (signed & stamped by partner)',
//       'Trade license (signed & stamped by partner)',
//       'GST (signed & stamped by partner)',
//       'KYC of partners (self attested)',
//       'Cancelled cheque',
//     ],
//     'Ltd/Private Limited': [
//       'Company PAN card (Signed & stamped by authorised director)',
//       'Company trade license (Signed & stamped by authorised director)',
//       'Company GST (Signed & stamped by authorised director)',
//       'Board resolution Original ( To be Signed & stamped by more than 50% director. In case of Ltd companies, Company secretary can sign the board resolution and authorised anyone in the organisation to sign)',
//       'KYC of directors (self attested)',
//       'List of Directors MCA - (Signed & stamped by authorised director)',
//       'Cancelled Cheque',
//     ],
//     'One person Company': [
//       'Company PAN card (Signed & stamped by sole director)',
//       'Company trade license (Signed & stamped by sole director)',
//       'Company GST (Signed & stamped by sole director)',
//       'Board resolution Original (Signed & stamped by sole director)',
//       'KYC of director (self attested)',
//       'List of Directors MCA (Signed & stamped by sole director)',
//       'Cancelled Cheque',
//     ],
//   };

//   Future<void> loginUser() async {
//     isLoading.value = true;

//     try {
//       String dealerName = userNameController.text.trim();
//       String contactNumber = phoneNumberController.text.trim();
//       final requestBody = {
//         "userName": dealerName,
//         "phoneNumber": contactNumber,
//         "password": passwordController.text.trim(),
//       };

//       print("Sending body: $requestBody");
//       final response = await ApiService.post(
//         endpoint: AppUrls.login,
//         body: requestBody,
//       );
//       final data = jsonDecode(response.body);
//       print("Status Code: ${response.statusCode}");
//       if (response.statusCode == 200) {
//         final token = data['token'];
//         final user = data['user'];
//         final userType = user['userType'];
//         final userId = user['id'];
//         final approvalStatus = user['approvalStatus'];

//       print("userType: $userType");
//       print("token: $token");
//       print("approvalStatus: $approvalStatus");
//       await SharedPrefsHelper.saveString(SharedPrefsHelper.userKey, jsonEncode(user));
//       await SharedPrefsHelper.saveString(SharedPrefsHelper.userTypeKey, userType);
//       await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);
//       print("userId: $userId");

//       if (userType == 'admin') {
//         await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);
//         print("Token saved in local: $token");
//         await SharedPrefsHelper.saveString(
//           SharedPrefsHelper.userKey,
//           jsonEncode(user),
//         );
//         await SharedPrefsHelper.saveString(
//           SharedPrefsHelper.userTypeKey,
//           userType,
//         );
//         await SharedPrefsHelper.saveString(SharedPrefsHelper.userIdKey, userId);
//         print("userId: $userId");
//         if (userType == 'admin') {
//           Get.to(() => AdminDashboard());
//         } else {
//           if (approvalStatus == 'Pending') {
//             Get.to(
//               () => WaitingForApprovalPage(
//                 documents:
//                     entityDocuments[selectedEntityType ?? 'Individual'] ??
//                     entityDocuments['Individual']!,
//                 userRole: userType,
//               ));
//         } else if (approvalStatus == 'Approved') {
//           await SharedPrefsHelper.saveString(SharedPrefsHelper.tokenKey, token);

//           if (userType == UserModel.customer) {
//             Get.to(() => CustomerHomepage());
//           } else if (userType == UserModel.salesManager) {
//             Get.to(() => SalesManagerHomepage());
//           } else if (userType == UserModel.dealer) {
//             Get.to(() => BottomNavigationPage());
//           }
//         } else if (approvalStatus == 'Rejected') {
//           Get.to(() => RejectedScreen(userId: userId));
//         } else {
//           ToastWidget.show(
//             context: Get.context!,
//             message: "Invalid approval status. Please contact admin.",
//             type: ToastType.error,
//           );
//         }
//       }
//     } else {
//       print("data: $data");
//       ToastWidget.show(
//         context: Get.context!,
//         message: data['message'] ?? "Invalid credentials",
//         type: ToastType.error,
//       );
//     }
//   } catch (e) {
//     print("Error: $e");
//     ToastWidget.show(
//       context: Get.context!,
//       message: e.toString(),
//       type: ToastType.error,
//     );
//   } finally {
//     isLoading.value = false;
//   }
// }

//   String? validatePassword(String password) {
//     if (password.isEmpty) return "Password is required.";
//     if (password.length < 8) {
//       return "Password must be at least 8 characters long.";
//     }
//     if (!RegExp(r'[A-Z]').hasMatch(password)) {
//       return "At least one uppercase letter required.";
//     }
//     if (!RegExp(r'[a-z]').hasMatch(password)) {
//       return "At least one lowercase letter required.";
//     }
//     if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
//       return "At least one special character required.";
//     }
//     return null;
//   }

//   Future<void> logout() async {
//     try {
//       await ApiService.post(endpoint: "user/logout/", body: {});
//       await SharedPrefsHelper.remove(SharedPrefsHelper.tokenKey);
//       await SharedPrefsHelper.remove(SharedPrefsHelper.userKey);
//       await SharedPrefsHelper.remove(SharedPrefsHelper.userTypeKey);

//       Get.offAll(() => LoginPage());
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar(
//         "Error",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade100,
//       );
//     }
//   }

//   // Clear fields
//   void clearFields() {
//     userNameController.clear();
//     phoneNumberController.clear();
//     passwordController.clear();
//     obsecureText.value = true;
//   }
// }
