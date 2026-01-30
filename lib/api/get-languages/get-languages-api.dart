import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetlanguagesApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  // GET /languages
  static Future<List<LanguageModel>> getLanguages() async {
    const String endpoint = "/languages";
    final uri = Uri.parse(_baseUrl + endpoint).replace(
      queryParameters: {"sortingDirection": "asc", "isPaginated": "false"},
    );

    final token = await readSecureData("AcessToken");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final List items = data["items"];
        return items.map((e) => LanguageModel.fromJson(e)).toList();
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}

class LanguageModel {
  final String id;
  final String name;
  final String? nativeName;
  final String code;
  final String? i18nPath;

  LanguageModel({
    required this.id,
    required this.name,
    this.nativeName,
    required this.code,
    this.i18nPath,
  });

  // JSON -> Model
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json["id"],
      name: json["name"],
      nativeName: json["nativeName"],
      code: json["code"],
      i18nPath: json["i18nPath"],
    );
  }
}
