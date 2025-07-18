import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/tab_bar_widget_controller.dart';
import 'package:otobix/Controllers/account_controller.dart';
import 'package:otobix/Controllers/bottom_navigation_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Dealer%20Panel/edit_account_page.dart';
import 'package:otobix/Views/Dealer%20Panel/user_preferences_page.dart';
import 'package:otobix/Views/Login/login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountController accountController = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
    accountController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Obx(() {
                          final imageUrl =
                              accountController
                                  .imageUrl
                                  .value; // make sure `user` is reactive

                          return CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                // ignore: unnecessary_null_comparison
                                imageUrl != null && imageUrl.isNotEmpty
                                    ? NetworkImage(
                                      imageUrl.startsWith('http')
                                          ? imageUrl
                                          : imageUrl,
                                    )
                                    : null,
                            child:
                                // ignore: unnecessary_null_comparison
                                imageUrl == null || imageUrl.isEmpty
                                    ? const Icon(Icons.person, size: 55)
                                    : null,
                          );
                        }),

                        SizedBox(height: 12),
                        Text(
                          accountController.username.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accountController.useremail.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  ProfileOption(
                    icon: Icons.edit,
                    color: Colors.green,
                    title: "Edit Profile",
                    description: "Change your name, email, and more.",
                    onTap: () {
                      Get.to(EditProfileScreen());
                    },
                  ),

                  ProfileOption(
                    icon: Icons.settings,
                    color: AppColors.grey,
                    title: "User Preferences",
                    description: "Set user preferences.",
                    onTap: () {
                      Get.to(UserPreferencesPage());
                    },
                  ),
                  ProfileOption(
                    icon: Icons.gavel,
                    color: Colors.blue,
                    title: "My Bids",
                    description: "View all your active and past bids.",
                    onTap: () {
                      final navController =
                          Get.find<BottomNavigationController>();
                      navController.currentIndex.value = 1;

                      final tabBarWidgetController =
                          Get.find<TabBarWidgetController>();
                      tabBarWidgetController.setSelectedTab(0);
                    },
                  ),
                  ProfileOption(
                    icon: Icons.favorite_border,
                    color: Colors.red,
                    title: "Wishlist",
                    description: "See cars you've saved for later.",
                    onTap: () {
                      final navController =
                          Get.find<BottomNavigationController>();
                      navController.currentIndex.value = 1;

                      final tabBarWidgetController =
                          Get.find<TabBarWidgetController>();
                      tabBarWidgetController.setSelectedTab(2);
                    },
                  ),
                  ProfileOption(
                    icon: Icons.settings,
                    color: Colors.blue,
                    title: "Settings",
                    description: "Manage your app preferences and account.",
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.logout,
                    color: Colors.red,
                    title: "Logout",
                    description: "Sign out of your account securely.",
                    onTap: () {
                      accountController.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? description;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: .5),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  description != null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
