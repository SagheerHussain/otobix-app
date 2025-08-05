import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_approved_users_list_page.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_rejected_users_list_page.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';
import 'package:otobix/admin/controller/admin_home_controller.dart';
import 'package:otobix/admin/controller/admin_pending_users_list_page.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final AdminHomeController getxController = Get.put(AdminHomeController());

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
                Flexible(child: _buildSearchBar(context)),

                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _buildRoleFilterDialog();
                  },
                  child: Image.asset(
                    AppImages.filterIcon,
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => Expanded(
              child: TabBarWidget(
                titles: ['Pending', 'Approved', 'Rejected'],
                counts: [
                  getxController.pendingUsersLength.value,
                  getxController.approvedUsersLength.value,
                  getxController.rejectedUsersLength.value,
                ],
                screens: [
                  AdminPendingUsersListPage(
                    searchQuery: getxController.searchQuery,
                  ),
                  AdminApprovedUsersListPage(
                    searchQuery: getxController.searchQuery,
                  ),
                  AdminRejectedUsersListPage(
                    searchQuery: getxController.searchQuery,
                  ),
                ],
                titleSize: 10,
                countSize: 8,
                spaceFromSides: 20,
                tabsHeight: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: getxController.searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,

          hintText: 'Search users...',
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha: .5),
            fontSize: 12,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
        ),
        onChanged: (value) {
          getxController.searchQuery.value = value.toLowerCase();
        },
      ),
    );
  }

  void _buildRoleFilterDialog() {
    final roles = [
      UserModel.dealer,
      UserModel.customer,
      UserModel.salesManager,
    ];
    final RxList<String> tempSelected = <String>[].obs;

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Filter by Role",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 0,
                  alignment: WrapAlignment.center,
                  children:
                      roles.map((role) {
                        final isSelected = tempSelected.contains(role);
                        return FilterChip(
                          label: Text(role),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              tempSelected.add(role);
                            } else {
                              tempSelected.remove(role);
                            }
                          },
                          selectedColor: AppColors.green.withValues(alpha: 0.1),
                          checkmarkColor: AppColors.green,
                          showCheckmark: true,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelStyle: TextStyle(
                            color:
                                isSelected ? AppColors.green : AppColors.black,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'Cancel',
                        isLoading: false.obs,
                        height: 30,
                        elevation: 3,
                        fontSize: 10,
                        backgroundColor: AppColors.red,
                        onTap: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ButtonWidget(
                        text: 'Apply',
                        isLoading: false.obs,
                        height: 30,
                        elevation: 3,
                        fontSize: 10,
                        onTap: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
