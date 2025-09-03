import 'package:flutter/material.dart';
import 'package:otobix/Widgets/empty_page_widget.dart';

class AdminUploadUserGuidePage extends StatelessWidget {
  const AdminUploadUserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmptyPageWidget(
                icon: Icons.book,
                title: 'No User Guide',
                description: 'You have no user guide yet.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
