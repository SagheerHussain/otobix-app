import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminApprovedUsersListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserModel> approvedUsersList = <UserModel>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchApprovedUsersList();
  }

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
}
