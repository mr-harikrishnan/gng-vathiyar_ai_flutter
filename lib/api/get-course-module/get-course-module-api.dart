import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetCourseModuleApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  static Future<CourseModuleModel> getCourseModule({
    required String courseId,
  }) async {
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

    if (response.statusCode != 200) {
      throw Exception("API Failed: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);
    return CourseModuleModel.fromJson(data);
  }
}

// ------------------ MODELS ------------------

// Main model
class CourseModuleModel {
  final String id;
  final String title;
  final bool isIntroCompleted;
  final bool isPreTestCompleted;
  final List<SectionModel> sections;

  CourseModuleModel({
    required this.id,
    required this.title,
    required this.isIntroCompleted,
    required this.isPreTestCompleted,
    required this.sections,
  });

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) {
    return CourseModuleModel(
      id: json["_id"].toString(),
      title: json["title"].toString(),

      // Default false if API sends null
      isIntroCompleted: json["isIntroCompleted"] == true,
      isPreTestCompleted: json["isPreTestCompleted"] == true,

      sections: (json["sections"] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList(),
    );
  }
}

// Section = Module
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

// Topic
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
    final rawQuizId = json["quizId"];

    return TopicModel(
      title: json["title"].toString(),

      // Always true or false
      isCompleted: json["isTopicCompleted"] == true,
      isQuizCompleted: json["isTopicQuizCompleted"] == true,

      // Only set real quiz id
      quizId: (rawQuizId != null && rawQuizId.toString().isNotEmpty)
          ? rawQuizId.toString()
          : null,

      contents: (json["topicId"]["contentIds"] as List)
          .map((e) => ContentModel.fromJson(e))
          .toList(),
    );
  }
}

// Content
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
