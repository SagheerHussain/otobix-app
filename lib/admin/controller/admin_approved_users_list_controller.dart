import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminApprovedUsersListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingUpdateUserThroughAdmin = false.obs;
  RxList<UserModel> approvedUsersList = <UserModel>[].obs;

  final formKey = GlobalKey<FormState>();

  final obscurePasswordText = true.obs;

  @override
  onInit() {
    super.onInit();
    fetchApprovedUsersList();
    listenToUpdatedUsersList();
  }

  // Fetch Approved Users List
  Future<void> fetchApprovedUsersList() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.approvedUsersList,
      );

      // Check for valid JSON response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> usersJson = data['users'] ?? [];

        approvedUsersList.value =
            usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        debugPrint("Error fetching approved users: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Error fetching approved users: ${response.statusCode}",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error fetching approved users: $e");
      ToastWidget.show(
        context: Get.context!,
        title: "Error fetching approved users",
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

  // Listen to updated users list
  void listenToUpdatedUsersList() {
    SocketService.instance.joinRoom(SocketEvents.adminHomeRoom);
    SocketService.instance.on(SocketEvents.updatedAdminHomeUsers, (data) {
      final List<dynamic> usersList = data['approvedUsersList'] ?? [];

      approvedUsersList.value =
          usersList.map((user) => UserModel.fromJson(user)).toList();
    });
  }
}
