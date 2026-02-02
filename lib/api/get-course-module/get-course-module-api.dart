import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetCourseModuleApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  // Use "Object?" for any type
  static Future<Object?> getCourseModule({required String courseId}) async {
    final uri = Uri.parse("$_baseUrl/learner-courses/$courseId");

    // Read token
    final token = await readSecureData("idToken");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // Check API status
    if (response.statusCode != 200) {
      throw Exception("API Failed: ${response.statusCode}");
    }

    // Decode JSON to Map or List (any type)
    final Object? data = jsonDecode(response.body);
                                
    // Return raw data (can be Map<String, dynamic> or List<dynamic>)
    return data;
  }
}
