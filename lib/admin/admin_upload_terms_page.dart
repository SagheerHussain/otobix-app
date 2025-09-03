// lib/screens/terms_upload_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/admin/controller/admin_upload_terms_controller.dart';

class AdminUploadTermsPage extends StatelessWidget {
  AdminUploadTermsPage({super.key}) {
    Get.put(AdminUploadTermsController(), permanent: true);
  }

  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminUploadTermsController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Form(
                //   key: _formKey,
                //   child: TextFormField(
                //     initialValue: c.titleCtrl.value,
                //     decoration: const InputDecoration(
                //       labelText: 'Title (optional)',
                //       hintText: 'e.g., Terms & Conditions — September 2025',
                //       border: OutlineInputBorder(),
                //     ),
                //     onChanged: c.setTitle,
                //   ),
                // ),
                // const SizedBox(height: 16),

                // File chooser row
                InkWell(
                  onTap: c.isUploading.value ? null : () => c.pickFile(),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            c.pickedFile.value?.name ?? 'Choose .docx or .pdf',
                            style: TextStyle(
                              color:
                                  c.pickedFile.value == null
                                      ? Colors.grey
                                      : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (c.pickedFile.value != null)
                          Text(
                            '${(c.pickedFile.value!.size / 1024).toStringAsFixed(1)} KB',
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Upload button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        c.isUploading.value || c.pickedFile.value == null
                            ? null
                            : () async {
                              await c.upload();
                            },
                    icon: const Icon(Icons.cloud_upload),
                    label:
                        c.isUploading.value
                            ? const Text('Uploading...')
                            : const Text('Upload'),
                  ),
                ),

                if (c.isUploading.value) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],

                const SizedBox(height: 12),

                // Result / server response preview
                Expanded(child: SingleChildScrollView(child: _ResponseCard())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminUploadTermsController>();

    return Obx(() {
      final r = c.lastResponse.value;
      if (r == null) {
        return const SizedBox.shrink();
      }

      // Try parsing JSON body to get version/title/fileName, else show raw
      Map<String, dynamic>? parsed;
      try {
        parsed = jsonDecode(r['body'] as String) as Map<String, dynamic>;
      } catch (_) {}

      Widget bodyWidget;
      if (parsed != null) {
        final data = parsed['data'] as Map<String, dynamic>?;
        bodyWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Status: ${r['statusCode']}',
            //   style: Theme.of(context).textTheme.titleMedium,
            // ),
            const SizedBox(height: 8),
            if (parsed['message'] != null)
              Text('Message: ${parsed['message']}'),
            const SizedBox(height: 8),
            if (data != null) ...[
              Text('Version: ${data['version'] ?? '-'}'),
              Text('Title: ${data['title'] ?? '-'}'),
              Text('File Name: ${data['fileName'] ?? '-'}'),
              const SizedBox(height: 8),
              Text(
                'Created At: ${data['createdAt'] ?? '-'}',
                style: const TextStyle(color: Colors.grey),
              ),
              // const Divider(height: 24),
              // Text(
              //   'Content (HTML preview trimmed):',
              //   style: Theme.of(context).textTheme.titleSmall,
              // ),
              // const SizedBox(height: 8),
              // Text(
              //   (data['content'] as String?)
              //           ?.replaceAll(RegExp(r'\s+'), ' ')
              //           .substring(
              //             0,
              //             ((data['content'] as String?)?.length ?? 0) > 600
              //                 ? 600
              //                 : ((data['content'] as String?)?.length ?? 0),
              //           ) ??
              //       '',
              //   maxLines: 12,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              // ),
            ] else
              Text(r['body']),
          ],
        );
      } else {
        bodyWidget = Text(
          'Status: ${r['statusCode']}\n\n${r['body']}',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        );
      }

      return Card(
        margin: const EdgeInsets.only(top: 8),
        elevation: 1,
        child: Padding(padding: const EdgeInsets.all(12), child: bodyWidget),
      );
    });
  }
}
