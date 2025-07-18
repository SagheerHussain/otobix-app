import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:otobix/Utils/app_urls.dart';

class ApiService {
  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(AppUrls.baseUrl + endpoint);
    print("GET: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.get(url, headers: defaultHeaders);
  }

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    print("POST: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.post(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(AppUrls.baseUrl + endpoint);
    print("PUT: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
  }
}
