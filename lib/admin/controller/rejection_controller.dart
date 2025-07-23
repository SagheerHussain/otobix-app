import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';

class UserCommentController extends GetxController {
  /// loading indicator
  RxBool isLoading = false.obs;

  /// fetched rejection comment
  RxString rejectionComment = "".obs;

  /// fetch user comment by userId
  Future<void> fetchUserComment(String userId) async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getUserStatus(userId),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final comment = data['user']['rejectionComment'] as String?;
        rejectionComment.value = comment ?? "";

        debugPrint("Fetched rejection comment: $comment");
      } else {
        debugPrint("Failed to fetch comment: ${data['message']}");
        rejectionComment.value = "";

        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to fetch comment.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      debugPrint("Error fetching comment: $e");
      rejectionComment.value = "";
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
