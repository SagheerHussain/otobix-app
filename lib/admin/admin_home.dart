import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/Login%20Register/user_model.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/admin/controller/admin_home_controller.dart';

class AdminHome extends StatelessWidget {
   AdminHome({super.key});
final AdminHomeController controller = Get.put(AdminHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [

          Expanded(
            child: TextField(
              // controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search Users...",
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
              },
            ),
          ),

          const SizedBox(width: 12),
         Image.asset(AppImages.filterIcon,height: 40,width: 40,)
        ],
      ),
    ),

    Expanded(
      child: Obx(() {
        final users = controller.usersList;

        if (users.isEmpty) {
          return const Center(
            child: Text(
              "No pending users!",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user, context);
          },
        );
      }),
    )
  ],
),

    );
  }
  Widget _buildUserCard(UserModel user, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 8),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Row → Avatar, name, location
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade50,
              child: Text(
                user.dealerName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),

            /// Name & email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    user.dealerName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.dealerEmail,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Icon(Icons.location_on,
                    size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 4),
                Text(
             user.location,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                user.userType,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                user.entityType,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Divider(color: Colors.grey.shade200, thickness: 1),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.approveUser(user.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Approve",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Reject
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showRejectDialog(context, user.id);
                  // controller.rejectUser(user.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Reject",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showRejectDialog(BuildContext context, String userId) {
  final TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Reject User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please enter a comment or reason for rejecting this user.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Type comment here...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final comment = commentController.text.trim();

              if (comment.isEmpty) {
                Get.snackbar(
                  "Validation",
                  "Comment cannot be empty.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade50,
                );
                return;
              }

              Navigator.pop(context);
              controller.updateUserStatus(
                userId: userId,
                approvalStatus: "Rejected",
                comment: comment,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Reject",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    },
  );
}


}
