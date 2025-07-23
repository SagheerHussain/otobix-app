import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminRejectedUserListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserModel> rejectedUsersList = <UserModel>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchRejectedUsersList();
  }

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
}
