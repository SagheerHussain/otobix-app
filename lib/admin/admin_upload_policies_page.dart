import 'package:flutter/material.dart';
import 'package:otobix/Widgets/empty_page_widget.dart';

class AdminUploadPoliciesPage extends StatelessWidget {
  const AdminUploadPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmptyPageWidget(
                icon: Icons.policy,
                title: 'No Policies',
                description: 'You have no policies yet.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
