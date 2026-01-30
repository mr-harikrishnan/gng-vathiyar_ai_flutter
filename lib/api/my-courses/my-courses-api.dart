import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetMyCoursesApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  // GET /my-courses
  static Future<List<CourseModel>> getMyCourses({
    required String status ,
    String? searchKey,
    String? lang,          
    String sortingDirection = "desc",
    int pageSize = 8,
    int pageNumber = 1,
    String orderByPropertyName = "_id", String? categoryId,
  }) async {
    const String endpoint = "/my-courses";

    // Build query params step by step
    final Map<String, String> queryParams = {
      "status": status,
      "sortingDirection": sortingDirection,
      "pageSize": pageSize.toString(),
      "pageNumber": pageNumber.toString(),
      "orderByPropertyName": orderByPropertyName,
    };

    if (lang != null && lang.isNotEmpty) {
      queryParams["lang"] = lang;
    }

    if (searchKey != null && searchKey.isNotEmpty) {
      queryParams["searchKey"] = searchKey;
    }

    final uri = Uri.parse(_baseUrl + endpoint).replace(
      queryParameters: queryParams,
    );

    print("GET My Courses URI: $uri");

    // Read token
    final token = await readSecureData("idToken");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    // Call API
    final response = await http.get(uri, headers: headers);
    print("response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // Get items list
        final List items = data["items"];

        // Convert JSON list to Model list
        return items.map((e) => CourseModel.fromJson(e)).toList();
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}

// -----------------------------
// COURSE MODEL
// -----------------------------
class CourseModel {
  final String id;
  final String title;
  final String subTitle;
  final String thumbnailImage;
  final int courseDuration;
  final int numberOfEnrolled;
  final String status;
  final String enrollType;
  final int completionPercent;
  final bool isCourseCompleted;
  final String updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.thumbnailImage,
    required this.courseDuration,
    required this.numberOfEnrolled,
    required this.status,
    required this.enrollType,
    required this.completionPercent,
    required this.isCourseCompleted,
    required this.updatedAt,
  });

  // JSON -> Model
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json["_id"] ?? "", // Some APIs send _id instead of id
      title: json["title"] ?? "",
      subTitle: json["subTitle"] ?? "",
      thumbnailImage: json["thumbnailImage"] ?? "",
      courseDuration: json["courseDuration"] ?? 0,
      numberOfEnrolled: json["numberOfEnrolled"] ?? 0,
      status: json["status"] ?? "",
      enrollType: json["enrollType"] ?? "",
      completionPercent: json["completionPercent"] ?? 0,
      isCourseCompleted: json["isCourseCompleted"] ?? false,
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}
