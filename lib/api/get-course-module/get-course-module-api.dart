// lib/api/get-course-module/get_course_module_api.dart
// FULL MODEL + API
// This fixes quiz status and avoids UI repeat issues

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetCourseModuleApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  // GET /learner-courses/{courseId}
  static Future<CourseModuleModel> getCourseModule({
    required String courseId,
  }) async {
    final String endpoint = "/learner-courses/$courseId";

    final uri = Uri.parse(_baseUrl + endpoint);

    // Read JWT token
    final token = await readSecureData("idToken");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // Convert JSON -> model
        return CourseModuleModel.fromJson(data);
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}

// ------------------ MODELS ------------------

// Main course model
class CourseModuleModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final bool isIntroCompleted;
  final bool isPreTestCompleted;
  final List<SectionModel> sections;

  CourseModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.isIntroCompleted,
    required this.isPreTestCompleted,
    required this.sections,
  });

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) {
    return CourseModuleModel(
      id: json["_id"].toString(),
      title: json["title"].toString(),
      description: json["description"].toString(),
      status: json["learnerCourseStatus"].toString(),

      // Flags for top rows
      isIntroCompleted: json["isIntroCompleted"] == true,
      isPreTestCompleted: json["isPreTestCompleted"] == true,

      sections: (json["sections"] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList(),
    );
  }
}

// Section model
class SectionModel {
  final String id;
  final String title;
  final List<TopicModel> topics;

  SectionModel({required this.id, required this.title, required this.topics});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json["_id"].toString(),
      title: json["title"].toString(),
      topics: (json["topics"] as List)
          .map((e) => TopicModel.fromJson(e))
          .toList(),
    );
  }
}

// Topic model
class TopicModel {
  final String title;
  final bool isCompleted;
  final bool isQuizCompleted;
  final String? quizId;
  final List<ContentModel> contents;

  TopicModel({
    required this.title,
    required this.isCompleted,
    required this.isQuizCompleted,
    required this.quizId,
    required this.contents,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      title: json["title"].toString(),

      // Video / content completed
      isCompleted: json["isTopicCompleted"] == true,

      // Quiz completed
      isQuizCompleted: json["isTopicQuizCompleted"] == true,

      // Quiz ID for navigation
      quizId: json["quizId"]?.toString(),

      contents: (json["topicId"]["contentIds"] as List)
          .map((e) => ContentModel.fromJson(e))
          .toList(),
    );
  }
}

// Content model
class ContentModel {
  final String id;
  final String type;
  final String url;
  final int duration;

  ContentModel({
    required this.id,
    required this.type,
    required this.url,
    required this.duration,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json["_id"].toString(),
      type: json["contentType"].toString(),
      url: json["url"].toString(),
      duration: json["duration"] ?? 0,
    );
  }
}
