// lib/api/get-categories/get_categories_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';

class GetCategoriesApiService {
  static const String _baseUrl = "https://devapi.appbuild.pro";

  // GET /categories
  static Future<List<CategoriesModel>> getCategories({
    String sortingDirection = "asc",
    String orderByPropertyName = "preference",
    String pageSize = "10000",
  }) async {
    const String endpoint = "/categories";

    final Map<String, String> queryParams = {
      "sortingDirection": sortingDirection,
      "orderByPropertyName": orderByPropertyName,
      "pageSize": pageSize,
    };

    final uri = Uri.parse(
      _baseUrl + endpoint,
    ).replace(queryParameters: queryParams);

    // Read JWT token from secure storage
    final token = await readSecureData("idToken");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // API returns list in "items"
        final List items = data["items"];

        // Convert JSON -> model list
        return items
            .map((e) => CategoriesModel.fromJson(e))
            .toList();
      } catch (e) {
        throw Exception("JSON Decode Failed: $e");
      }
    } else {
      throw Exception("GET Failed: ${response.statusCode}");
    }
  }
}

class CategoriesModel {
  final String id;
  final String name;

  CategoriesModel({
    required this.id,
    required this.name,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
    );
  }
}
