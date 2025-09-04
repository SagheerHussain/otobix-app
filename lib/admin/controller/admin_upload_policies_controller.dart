import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:otobix/Utils/app_urls.dart';

class AdminUploadPoliciesController extends GetxController {
  /// UI State
  final titleCtrl = RxString('');
  final isUploading = false.obs;
  final pickedFile = Rxn<PlatformFile>();
  final lastResponse = Rxn<Map<String, dynamic>>(); // store response for UI

  void setTitle(String v) => titleCtrl.value = v;

  Future<void> pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: kIsWeb, // we need bytes on web
      allowedExtensions: ['docx', 'pdf'],
    );
    if (res != null && res.files.isNotEmpty) {
      pickedFile.value = res.files.first;
    }
  }

  Future<void> upload() async {
    final file = pickedFile.value;
    if (file == null) {
      Get.snackbar('Missing file', 'Please choose a .docx or .pdf first.');
      return;
    }

    final hasTitle = titleCtrl.value.trim().isNotEmpty;
    final uri = Uri.parse(AppUrls.uploadPrivacyPolicy);
    final req = http.MultipartRequest('POST', uri);

    // optional title
    if (hasTitle) req.fields['title'] = titleCtrl.value.trim();

    // file part
    final filename = file.name;
    final lower = filename.toLowerCase();
    final isDocx = lower.endsWith('.docx');
    final isPdf = lower.endsWith('.pdf');

    // Basic content-type
    final MediaType contentType =
        isDocx
            ? MediaType(
              'application',
              'vnd.openxmlformats-officedocument.wordprocessingml.document',
            )
            : MediaType('application', 'pdf');

    http.MultipartFile multipart;

    if (kIsWeb) {
      final bytes = file.bytes;
      if (bytes == null) {
        Get.snackbar('Error', 'Could not read file bytes on web.');
        return;
      }
      multipart = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: contentType,
      );
    } else {
      final path = file.path;
      if (path == null) {
        Get.snackbar('Error', 'Invalid file path.');
        return;
      }
      multipart = await http.MultipartFile.fromPath(
        'file',
        path,
        filename: filename,
        contentType: contentType,
      );
    }

    req.files.add(multipart);

    try {
      isUploading.value = true;
      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = resp.body.isNotEmpty ? resp.body : '{}';
        lastResponse.value = {'statusCode': resp.statusCode, 'body': data};
        Get.snackbar('Success', 'Terms uploaded successfully.');
      } else {
        lastResponse.value = {'statusCode': resp.statusCode, 'body': resp.body};
        Get.snackbar(
          'Upload failed',
          'Server responded with ${resp.statusCode}. Check logs.',
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }

  void reset() {
    titleCtrl.value = '';
    pickedFile.value = null;
    lastResponse.value = null;
  }

  @override
  void onClose() {
    // No TextEditingController here; using RxString
    super.onClose();
  }
}
