import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/Login%20Register/user_model.dart';
import 'package:otobix/Network/api_service.dart';

class AdminHomeController extends GetxController {

  RxBool isLoading = false.obs;
  RxList<UserModel> usersList = <UserModel>[].obs;
onInit() {
    super.onInit();
    fetchAllUsers();
  }
  Future<void> fetchAllUsers() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(endpoint: "user/all-users");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> usersJson = data['users'] ?? [];

        usersList.value = usersJson
            .map((json) => UserModel.fromJson(json))
            .toList();

        print("Fetched users: ${usersList.length}");
      } else {
        debugPrint("Failed to fetch users: ${response.body}");
        Get.snackbar(
          "Error",
          "Failed to fetch users",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      print("Error fetching users: $e");
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
      endpoint: "user/update-user-status/$userId",
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        data['message'] ?? "User status updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
      );

      fetchAllUsers();

    } else {
      debugPrint("Failed to update user: ${response.body}");
      Get.snackbar(
        "Error",
        data['message'] ?? "Failed to update user status.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  } catch (e) {
    print("Error updating user: $e");
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






Future<void> approveUser(String userId) async {
  isLoading.value = true;

  try {
    final body = {
      "approvalStatus": "Approved",
    };

    final response = await ApiService.put(
      endpoint: "user/update-user-status/$userId",
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        data['message'] ?? "User approved successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
      );


      fetchAllUsers();
    } else {
      debugPrint("Failed to approve user: ${response.body}");
      Get.snackbar(
        "Error",
        data['message'] ?? "Failed to approve user.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  } catch (e) {
    print("Error approving user: $e");
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
}


