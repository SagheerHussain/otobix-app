import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:4000/api/";
  // static const String baseUrl = "https://otobix-app-backend.onrender.com/api/";

  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
    print("GET: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.get(url, headers: defaultHeaders);
  }

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(baseUrl + endpoint);
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
    final url = Uri.parse(baseUrl + endpoint);
    print("PUT: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
  }
}
