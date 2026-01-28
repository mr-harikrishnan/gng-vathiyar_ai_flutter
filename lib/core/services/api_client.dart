// lib/core/services/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secureStorage/secure_storage.dart';

import '../constants/api_constants.dart';

class ApiClient {
  // Build headers
  Future<Map<String, String>> _headers() async {
    final token = await readSecureData("AcessToken");

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

    final response = await http.get(uri, headers: await _headers());

    // Check status
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}
