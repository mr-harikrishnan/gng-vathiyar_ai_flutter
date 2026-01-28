// lib/core/services/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secureStorage/secure_storage.dart';

import '../constants/api_constants.dart';

class ApiClient {
  // Build headers
  Future<Map<String, String>> _headers() async {
    final token = await readSecureData("AcessToken");
    print("Auth Token: $token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // Common GET
  Future<dynamic> get(String endpoint, {Map<String, String>? query}) async {
    final uri = Uri.parse(
      ApiConstants.baseUrl + endpoint,
    ).replace(queryParameters: query);
    print("Request URL: $uri");
    final headers = await _headers();
    print("Request Headers: $headers");
    final response = await http.get(uri, headers: headers);
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    // Check status
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}
