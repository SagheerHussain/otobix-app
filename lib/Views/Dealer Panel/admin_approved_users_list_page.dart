import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';
import 'package:otobix/admin/controller/admin_approved_users_list_controller.dart';

class AdminApprovedUsersListPage extends StatelessWidget {
  final RxString searchQuery;
  AdminApprovedUsersListPage({super.key, required this.searchQuery});

  final getxController = Get.put(AdminApprovedUsersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (getxController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // search users
        final filteredUsers =
            getxController.approvedUsersList.where((user) {
              final query = searchQuery.value.toLowerCase();
              final name = user.userName.toLowerCase();
              final email = user.email.toLowerCase();
              return name.contains(query) || email.contains(query);
            }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: EmptyDataWidget(message: "No approved users found."),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: filteredUsers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _buildUserCard(user);
          },
        );
      }),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return InkWell(
      onTap: () => _buildUserDetailsBottomSheet(user),
      borderRadius: BorderRadius.circular(12),
      child: Card(
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
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // if (user.dealershipName != null &&
                    //     user.dealershipName!.isNotEmpty)
                    //   Text("Dealership: ${user.dealershipName!}"),
                    Text(
                      "Phone: ${user.phoneNumber}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
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
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        user.userRole,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
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
      ),
    );
  }

  void _buildUserDetailsBottomSheet(UserModel user) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          initialChildSize: 0.7,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          user.image != null && user.image!.isNotEmpty
                              ? NetworkImage(user.image!)
                              : null,
                      child:
                          user.image == null || user.image!.isEmpty
                              ? Text(
                                user.userName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 28),
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const Divider(height: 30),

                  _infoTile("Role", user.userRole),
                  _infoTile("Phone", user.phoneNumber),
                  _infoTile("Location", user.location),
                  if (user.dealershipName != null &&
                      user.dealershipName!.isNotEmpty)
                    _infoTile("Dealership", user.dealershipName!),
                  if (user.entityType != null && user.entityType!.isNotEmpty)
                    _infoTile("Entity Type", user.entityType!),
                  if (user.primaryContactPerson != null &&
                      user.primaryContactPerson!.isNotEmpty)
                    _infoTile("Primary Contact", user.primaryContactPerson!),
                  if (user.primaryContactNumber != null &&
                      user.primaryContactNumber!.isNotEmpty)
                    _infoTile("Primary Number", user.primaryContactNumber!),
                  if (user.secondaryContactPerson != null &&
                      user.secondaryContactPerson!.isNotEmpty)
                    _infoTile(
                      "Secondary Contact",
                      user.secondaryContactPerson!,
                    ),
                  if (user.secondaryContactNumber != null &&
                      user.secondaryContactNumber!.isNotEmpty)
                    _infoTile("Secondary Number", user.secondaryContactNumber!),
                  if (user.createdAt != null)
                    _infoTile(
                      "Approved On",
                      DateFormat('dd MMM yyyy').format(user.createdAt!),
                    ),
                  if (user.addressList.isNotEmpty)
                    _infoTile("Addresses", user.addressList.join(", ")),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
