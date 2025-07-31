import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminRejectedUserListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingUpdateUserThroughAdmin = false.obs;
  RxList<UserModel> rejectedUsersList = <UserModel>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchRejectedUsersList();
  }

  final formKey = GlobalKey<FormState>();

  final obscurePasswordText = true.obs;

  // Fetch Rejected Users List
  Future<void> fetchRejectedUsersList() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.rejectedUsersList,
      );

      // Check for valid JSON response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> usersJson = data['users'] ?? [];

        rejectedUsersList.value =
            usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        debugPrint("Error fetching rejected users: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error fetching rejected users: ${response.statusCode}",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error fetching rejected users: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error fetching rejected users",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update User Through Admin
  Future<void> updateUserThroughAdmin({
    required String userId,
    required String status,
    required String password,
  }) async {
    isLoadingUpdateUserThroughAdmin.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.updateUserThroughAdmin(userId),
        body: {'password': password, 'approvalStatus': status},
      );

      // Check for valid JSON response
      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User updated successfully",
          type: ToastType.success,
        );
      } else if (response.statusCode == 404) {
        ToastWidget.show(
          context: Get.context!,
          title: "User not found",
          type: ToastType.error,
        );
      } else {
        debugPrint("Error updating user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error updating user.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error updating user: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error updating user.",
        type: ToastType.error,
      );
    } finally {
      isLoadingUpdateUserThroughAdmin.value = false;
    }
  }
}
