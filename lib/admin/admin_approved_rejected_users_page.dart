import 'package:flutter/material.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_approved_users_list_page.dart';
import 'package:otobix/Views/Dealer%20Panel/admin_rejected_users_list_page.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';

class AdminApprovedRejectedUsersPage extends StatelessWidget {
  const AdminApprovedRejectedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            // SizedBox(height: 20),
            Expanded(
              child: TabBarWidget(
                titles: ['Approved Users', 'Rejected Users'],
                counts: [0, 0],
                screens: [
                  AdminApprovedUsersListPage(),
                  AdminRejectedUsersListPage(),
                ],
                titleSize: 10,
                countSize: 8,
                spaceFromSides: 20,
                tabsHeight: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
