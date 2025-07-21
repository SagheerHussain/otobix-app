import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/admin/controller/admin_approved_users_list_controller.dart';

class AdminApprovedUsersListPage extends StatelessWidget {
  AdminApprovedUsersListPage({super.key});

  final getxController = Get.put(AdminApprovedUsersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (getxController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (getxController.approvedUsersList.isEmpty) {
          return Center(
            child: Text(
              "No approved users found.",
              style: TextStyle(color: AppColors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: getxController.approvedUsersList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = getxController.approvedUsersList[index];
            return _buildUserCard(user);
          },
        );
      }),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  user.image != null && user.image!.isNotEmpty
                      ? NetworkImage(user.image!)
                      : null,
              child:
                  user.image == null || user.image!.isEmpty
                      ? Text(user.userName.substring(0, 1).toUpperCase())
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email.trim(),
                    style: const TextStyle(fontSize: 13, color: AppColors.grey),
                  ),
                  const SizedBox(height: 4),
                  // if (user.dealershipName != null &&
                  //     user.dealershipName!.isNotEmpty)
                  //   Text("Dealership: ${user.dealershipName!}"),
                  Text(
                    "Phone: ${user.phoneNumber}",
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                  // Text("Location: ${user.location}"),
                  if (user.createdAt != null)
                    Text(
                      "Approved on: ${DateFormat('dd MMM yyyy').format(user.createdAt!)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                'Approved',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
