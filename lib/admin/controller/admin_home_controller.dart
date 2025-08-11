import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/Models/user_model.dart';

class AdminHomeController extends GetxController {
  // loading
  RxBool isLoading = false.obs;
  RxBool isLoadingUsersLength = false.obs;

  // search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Selected roles for filtering.
  /// Default to ["All"].
  final RxList<String> selectedRoles = <String>['All'].obs;

  // tabs counters
  RxInt pendingUsersLength = 0.obs;
  RxInt approvedUsersLength = 0.obs;
  RxInt rejectedUsersLength = 0.obs;

  // roles list used in UI
  final List<String> roles = [
    'All',
    AppConstants.roles.dealer,
    AppConstants.roles.customer,
    AppConstants.roles.salesManager,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUsersLength();
  }

  // fetch users length
  Future<void> fetchUsersLength() async {
    isLoadingUsersLength.value = true;
    try {
      final response = await ApiService.get(endpoint: AppUrls.usersLength);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pendingUsersLength.value = data['pendingUsersLength'] ?? 0;
        approvedUsersLength.value = data['approvedUsersLength'] ?? 0;
        rejectedUsersLength.value = data['rejectedUsersLength'] ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching users length: $e");
      if (Get.context != null) {
        ToastWidget.show(
          context: Get.context!,
          title: "Error fetching users length",
          type: ToastType.error,
        );
      }
    } finally {
      isLoadingUsersLength.value = false;
    }
  }

  /// Enforce the "All" exclusivity rule and never leave empty.
  void applyRoleSelection(List<String> picked) {
    // If nothing picked, default to All.
    if (picked.isEmpty) {
      selectedRoles.assignAll(['All']);
      return;
    }

    // If All is picked (alone or with others), keep only All.
    if (picked.contains('All')) {
      selectedRoles.assignAll(['All']);
      return;
    }

    // Otherwise keep only the specific roles (ensure All is not included)
    selectedRoles.assignAll(picked.where((r) => r != 'All'));
  }

  /// Helper for consumers: does this role pass current filter?
  bool roleMatches(String userRole) {
    final sel = selectedRoles;
    if (sel.contains('All')) return true;
    return sel.contains(userRole);
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix/Network/api_service.dart';
// import 'package:otobix/Utils/app_urls.dart';
// import 'package:otobix/Widgets/toast_widget.dart';

// class AdminHomeController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool isLoadingUsersLength = false.obs;

//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;

//   RxString selectedRole = 'All'.obs;

//   RxInt pendingUsersLength = 0.obs;
//   RxInt approvedUsersLength = 0.obs;
//   RxInt rejectedUsersLength = 0.obs;

//   @override
//   onInit() {
//     super.onInit();
//     fetchUsersLength();
//   }

//   // fetch users length
//   Future<void> fetchUsersLength() async {
//     isLoadingUsersLength.value = true;

//     try {
//       final response = await ApiService.get(endpoint: AppUrls.usersLength);

//       // Check for valid JSON response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         pendingUsersLength.value = data['pendingUsersLength'] ?? 0;
//         approvedUsersLength.value = data['approvedUsersLength'] ?? 0;
//         rejectedUsersLength.value = data['rejectedUsersLength'] ?? 0;
//       }
//     } catch (e) {
//       debugPrint("Error fetching users length: $e");
//       ToastWidget.show(
//         context: Get.context!,
//         title: "Error fetching users length",
//         type: ToastType.error,
//       );
//     } finally {
//       isLoadingUsersLength.value = false;
//     }
//   }
// }
