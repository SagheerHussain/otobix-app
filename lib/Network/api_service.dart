import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:otobix/Utils/app_urls.dart';

class ApiService {
  // static const String baseUrl = "https://otobix-app-backend.onrender.com/api";

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    final response = await http.post(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );

    return response;
  }

  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    final response = await http.get(url, headers: defaultHeaders);

    return response;
  }

  static Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    final response = await http.put(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );

    return response;
  }
}
