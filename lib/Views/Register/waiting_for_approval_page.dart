import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otobix/Utils/app_animations.dart';
import 'package:otobix/Utils/app_colors.dart';

class WaitingForApprovalPage extends StatelessWidget {
  final List<String> documents;

  const WaitingForApprovalPage({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Approval Status'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Illustration
            // Icon(Icons.hourglass_empty, size: 50, color: AppColors.green),
            Lottie.asset(AppAnimations.waitingAnimation, height: 100),
            const SizedBox(height: 20),

            // Main Title
            const Text(
              'Waiting for Approval',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Your account is currently under review. '
                        'Please check your email for details to pay the required security deposit. '
                        'After completing the payment, ',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  TextSpan(
                    text:
                        'kindly submit the following documents along with your payment receipt for verification.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Documents List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doc = documents[index];
                return _buildDocumentCard(doc);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String docName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.description, color: AppColors.green, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              docName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
