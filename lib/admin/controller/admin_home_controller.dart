import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminHomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserModel> usersList = <UserModel>[].obs;
  RxList<UserModel> filteredUsersList = <UserModel>[].obs;

  TextEditingController searchController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    fetchPendingUsersList();
    filteredUsersList.value = usersList;
  }

  // search
  void filterUsers() {
    final query = searchController.text.toLowerCase();
    filteredUsersList.value =
        usersList.where((user) {
          return user.userName.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        }).toList();
  }

  Future<void> fetchPendingUsersList() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(endpoint: AppUrls.pendingUsersList);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> usersJson = data['users'] ?? [];

        usersList.value =
            usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        debugPrint("Unexpected response format: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Unexpected response. Please try again.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error fetching users",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserStatus({
    required String userId,
    required String approvalStatus,
    String? comment,
  }) async {
    isLoading.value = true;

    try {
      final body = {
        "approvalStatus": approvalStatus,
        if (comment != null) "comment": comment,
      };

      final response = await ApiService.put(
        endpoint: AppUrls.updateUserStatus(userId),
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User status updated successfully.",
          type: ToastType.success,
        );

        fetchPendingUsersList();
      } else {
        debugPrint("Failed to update user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to update user status.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error updating user",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveUser(String userId) async {
    isLoading.value = true;

    try {
      final body = {"approvalStatus": "Approved"};

      final response = await ApiService.put(
        endpoint: AppUrls.updateUserStatus(userId),
        body: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "User approved successfully.",
          type: ToastType.success,
        );

        fetchPendingUsersList();
      } else {
        debugPrint("Failed to approve user: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to approve user.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error approving user",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
