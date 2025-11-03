import 'package:flutter/material.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  static const String deleteAccountUrl =
      'https://docs.google.com/document/d/e/2PACX-1vSKyBpIkF9VIJvIcbFST43UibHpVYAkH4NCBY0k_MWPl1XtyEhHMLouxdbapgVao_ZPeXBL4KRkoTAg/pub';

  @override
  Widget build(BuildContext context) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              // If the page links out to mailto:, tel:, etc., open externally
              onNavigationRequest: (request) async {
                final uri = Uri.parse(request.url);
                final isHttp = uri.scheme == 'http' || uri.scheme == 'https';
                if (!isHttp) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(deleteAccountUrl));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Account',
          style: TextStyle(fontSize: 16, color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
