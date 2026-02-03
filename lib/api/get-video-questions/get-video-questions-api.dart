import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetVideoQuestions {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  static Future<List<VideoQuestionModel>> getVideoQuestions(
      {required String contentId}) async {
    const String endpoint = "/videos-questions";
    final uri = Uri.parse(_baseUrl + endpoint).replace(
      queryParameters: {
        "contentId": contentId,
        "sortingDirection": "asc",
        "isPaginated": "false"
      },
    );

    final token = await readSecureData("idToken");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final List items = data["items"];
        return items.map((e) => VideoQuestionModel.fromJson(e)).toList();
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}

class VideoQuestionModel {
  final String? id;
  final String? contentId;
  final String? title;
  final String? url;
  final List<dynamic>? questions;

  VideoQuestionModel({
    this.id,
    this.contentId,
    this.title,
    this.url,
    this.questions,
  });

  // From JSON
  factory VideoQuestionModel.fromJson(Map<String, dynamic> json) {
    return VideoQuestionModel(
      id: json['id'],
      contentId: json['contentId'],
      title: json['title'],
      url: json['url'],
      questions: json['questions'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'title': title,
      'url': url,
      'questions': questions,
    };
  }
}
