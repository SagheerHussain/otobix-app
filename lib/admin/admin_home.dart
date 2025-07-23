import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';
import 'package:otobix/Widgets/search_bar_widget.dart';
import 'package:otobix/Widgets/shimmer_widget.dart';
import 'package:otobix/admin/controller/admin_home_controller.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  final AdminHomeController controller = Get.put(AdminHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 10,
        foregroundColor: AppColors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Flexible(
                  child: SearchBarWidget(
                    controller: controller.searchController,
                    hintText: 'Search users...',
                    onChanged: (value) {
                      controller.filterUsers();
                    },
                  ),
                ),

                // Expanded(
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: "Search Users...",
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: Colors.grey.shade400,
                //       ),
                //       filled: true,
                //       fillColor: Colors.white,
                //       contentPadding: EdgeInsets.symmetric(
                //         vertical: 12,
                //         horizontal: 16,
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(12),
                //         borderSide: BorderSide.none,
                //       ),
                //     ),
                //     onChanged: (value) {},
                //   ),
                // ),
                const SizedBox(width: 12),
                Image.asset(AppImages.filterIcon, height: 30, width: 30),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              // final users = controller.usersList;

              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return _buildShimmerCard();
                  },
                );
              }

              if (controller.filteredUsersList.isEmpty) {
                return const Center(
                  child: EmptyDataWidget(
                    icon: Icons.person,
                    message: "No users found!",
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredUsersList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = controller.filteredUsersList[index];
                  return _buildUserCard(user, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
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
                  user.userName.substring(0, 1).toUpperCase(),
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
                      user.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user.email,
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
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.blue.shade600,
                  ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  user.userRole,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  // user.entityType!,
                  'Individual',
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Reject User",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12.withValues(alpha: 0.05),
        //     blurRadius: 15,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row → Avatar, name, location
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ShimmerWidget(width: 56, height: 56, borderRadius: 50),
              const SizedBox(width: 12),

              /// Name & email shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(width: 120, height: 14),
                    SizedBox(height: 8),
                    ShimmerWidget(width: 100, height: 12),
                  ],
                ),
              ),

              /// Location shimmer
              const SizedBox(width: 8),
              const ShimmerWidget(width: 80, height: 14),
            ],
          ),

          const SizedBox(height: 16),

          /// Role & Entity shimmer tags
          Row(
            children: const [
              ShimmerWidget(width: 60, height: 20, borderRadius: 30),
              SizedBox(width: 8),
              ShimmerWidget(width: 70, height: 20, borderRadius: 30),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          /// Approve & Reject buttons shimmer
          Row(
            children: const [
              Expanded(child: ShimmerWidget(height: 42, borderRadius: 12)),
              SizedBox(width: 12),
              Expanded(child: ShimmerWidget(height: 42, borderRadius: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildShimmerCard1() {
  //   return Shimmer.fromColors(
  //     baseColor: Colors.grey.shade300,
  //     highlightColor: Colors.grey.shade100,
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       margin: const EdgeInsets.symmetric(vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black12.withOpacity(0.05),
  //             blurRadius: 15,
  //             offset: const Offset(0, 8),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           /// Avatar, Name, Email, Location
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               /// Avatar shimmer
  //               Container(
  //                 height: 56,
  //                 width: 56,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   shape: BoxShape.circle,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),

  //               /// Name, Email shimmer
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       height: 14,
  //                       width: 120,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       height: 12,
  //                       width: 180,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //               /// Location shimmer
  //               Column(
  //                 children: [
  //                   const SizedBox(height: 6),
  //                   Container(
  //                     height: 12,
  //                     width: 80,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),

  //           const SizedBox(height: 20),

  //           /// Role + EntityType shimmer chips
  //           Row(
  //             children: [
  //               Container(
  //                 height: 20,
  //                 width: 70,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Container(
  //                 height: 20,
  //                 width: 90,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //             ],
  //           ),

  //           const SizedBox(height: 20),

  //           /// Divider
  //           Container(height: 1, color: Colors.grey.shade200),

  //           const SizedBox(height: 20),

  //           /// Buttons shimmer
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Container(
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Container(
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
