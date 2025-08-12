import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/helpers/Preferences_helper.dart';
import '../Models/user_notifications_model.dart';

class UserNotificationsController extends GetxController {
  final RxList<UserNotificationsModel> items = <UserNotificationsModel>[].obs;
  final RxBool loading = false.obs;
  final RxInt unreadCount = 0.obs;
  int page = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    refreshList();
  }

  // REFRESH NOTIFICATIONS LIST
  Future<void> refreshList() async {
    page = 1;
    hasMore = true;
    items.clear();
    await fetchMore();
  }

  // FETCH NOTIFICATIONS LIST
  Future<void> fetchMore() async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    if (loading.value || !hasMore) return;
    loading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.userNotificationsList(
          userId: userId,
          page: page,
          limit: limit,
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        unreadCount.value = data['unreadCount'] ?? 0;
        final list =
            (data['items'] as List? ?? [])
                .map(
                  (e) => UserNotificationsModel.fromJson(
                    documentId: e['_id'] as String,
                    data: e as Map<String, dynamic>,
                  ),
                )
                .toList();
        if (list.isEmpty) {
          hasMore = false;
        } else {
          items.addAll(list);
          page++;
        }
      }
    } finally {
      loading.value = false;
    }
  }

  // FETCH NOTIFICATION DETAIL
  Future<UserNotificationsModel?> fetchNotificationDetails(
    String notificationId,
  ) async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    final response = await ApiService.get(
      endpoint: AppUrls.userNotificationsDetail(
        userId: userId,
        notificationId: notificationId,
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // handle both shapes safely
      final item = (data['item'] ?? data) as Map<String, dynamic>;
      final id = (item['_id'] ?? item['id'])?.toString() ?? '';

      return UserNotificationsModel.fromJson(documentId: id, data: item);
    }
    return null;
  }

  // MARK NOTIFICATION AS READ
  Future<void> markNotificationAsRead(String notificationId) async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    final response = await ApiService.post(
      endpoint: AppUrls.userNotificationsMarkRead,
      body: {'userId': userId, 'notificationId': notificationId},
    );
    if (response.statusCode == 200) {
      final i = items.indexWhere((e) => e.id == notificationId);
      if (i != -1 && items[i].isRead == false) {
        final n = items[i];
        items[i] = UserNotificationsModel(
          id: n.id,
          userId: n.userId,
          type: n.type,
          title: n.title,
          body: n.body,
          data: n.data,
          isRead: true,
          createdAt: n.createdAt,
        );
        if (unreadCount.value > 0) unreadCount.value--;
      }
    }
  }

  // MARK ALL NOTIFICATIONS AS READ
  Future<void> markAllNotificationsAsRead() async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    final response = await ApiService.post(
      endpoint: AppUrls.userNotificationsMarkAllRead,
      body: {'userId': userId},
    );
    if (response.statusCode == 200) {
      for (var i = 0; i < items.length; i++) {
        if (!items[i].isRead) {
          final n = items[i];
          items[i] = UserNotificationsModel(
            id: n.id,
            userId: n.userId,
            type: n.type,
            title: n.title,
            body: n.body,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
      }
      unreadCount.value = 0;
    }
  }
}
