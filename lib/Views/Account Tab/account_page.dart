import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/Widgets/tab_bar_widget_controller.dart';
import 'package:otobix/Controllers/bottom_navigation_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Login/login_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Profile Photo + Name
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.green.withValues(alpha: .3),
                        child: Icon(
                          Icons.person,
                          color: AppColors.green,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Amit Parekh",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "amit.parekh@otobix.com",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Account Options
                ProfileOption(
                  icon: Icons.edit,
                  color: Colors.green,
                  title: "Edit Profile",
                  description: "Change your name, email, and more.",
                  onTap: () {},
                ),
                ProfileOption(
                  icon: Icons.gavel,
                  color: Colors.blue,
                  title: "My Bids",
                  description: "View all your active and past bids.",
                  onTap: () {
                    final navController =
                        Get.find<BottomNavigationController>();
                    navController.currentIndex.value = 1; // Go to My Cars tab

                    final tabBarWidgetController =
                        Get.find<TabBarWidgetController>();
                    tabBarWidgetController.setSelectedTab(0);
                  },
                ),
                ProfileOption(
                  icon: Icons.favorite_border,
                  color: Colors.red,
                  title: "Wishlist",
                  description: "See cars you’ve saved for later.",
                  onTap: () {
                    final navController =
                        Get.find<BottomNavigationController>();
                    navController.currentIndex.value = 1; // Go to My Cars tab

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
                    Get.offAll(() => LoginPage());
                  },
                ),
              ],
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
                /// Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),

                /// Title & Description
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

                /// Chevron
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
