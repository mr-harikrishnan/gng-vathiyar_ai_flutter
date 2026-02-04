// lib/features/in-progress/in-progress.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-languages/get-languages-api.dart';
import 'package:vathiyar_ai_flutter/api/get-my-courses/get-my-courses-api.dart';
import 'package:vathiyar_ai_flutter/widgets/course-card.dart';
import 'package:vathiyar_ai_flutter/widgets/drop-down.dart';
import 'package:vathiyar_ai_flutter/widgets/search-bar.dart';

class InProgress extends StatefulWidget {
  const InProgress({super.key});

  @override
  State<InProgress> createState() => InProgressState();
}

class InProgressState extends State<InProgress> {
  // Course list
  List<CourseModel> _courseModels = [];

  // Language dropdown
  List<String> _languages = ["All Languages"];
  String _selectedLanguage = "All Languages";

  // Name -> Code map
  Map<String, String> _languageMap = {};

  // Search text
  String _searchQuery = "";

  // Loading flag
  bool _loadingCourses = true;

  // Debounce timer
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Load languages + courses
  Future<void> _loadInitialData() async {
    await _loadLanguages();
    await _loadCourses();
  }

  // Load languages from API
  Future<void> _loadLanguages() async {
    try {
      final result = await GetlanguagesApiService.getLanguages();

      // Build name -> code map
      _languageMap = {for (var e in result) e.name: e.code};

      setState(() {
        _languages = ["All Languages", ..._languageMap.keys];
      });
    } catch (e) {
      debugPrint("API Error (Languages): $e");
    }
  }

  // Load courses for IN_PROGRESS
  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
    });

    // Convert name -> code
    String? langParam;
    if (_selectedLanguage != "All Languages") {
      langParam = _languageMap[_selectedLanguage];
    }

    // Search param
    String? searchParam;
    if (_searchQuery.isNotEmpty) {
      searchParam = _searchQuery;
    }

    try {
      final result = await GetMyCoursesApiService.getMyCourses(
        status: "IN_PROGRESS",
        lang: langParam,
        searchKey: searchParam,
        sortingDirection: "desc",
        pageSize: 8,
        pageNumber: 1,
        orderByPropertyName: "_id",
      );

      setState(() {
        _courseModels = result;
        _loadingCourses = false;
      });
    } catch (e) {
      debugPrint("API Error (Courses): $e");
      setState(() {
        _loadingCourses = false;
      });
    }
  }

  // Dropdown change
  void _onLanguageChanged(String? newValue) {
    if (newValue == null) return;

    if (newValue == _selectedLanguage) return;

    setState(() {
      _selectedLanguage = newValue;
    });

    _loadCourses();
  }

  // Search with debounce
  void _onSearchChanged(String text) {
    _searchQuery = text;

    if (text.isEmpty) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Language dropdown
          Dropdown(
            value: _selectedLanguage,
            languages: _languages,
            onChanged: _onLanguageChanged,
          ),

          const SizedBox(height: 10),

          // Search bar
          SearchBarWidget(onChanged: _onSearchChanged),

          const SizedBox(height: 20),

          // Course list
          Expanded(
            child: _loadingCourses
                ? const Center(child: CircularProgressIndicator())
                : _courseModels.isEmpty
                ? const Center(child: Text("No courses found."))
                : ListView.builder(
                    itemCount: _courseModels.length,
                    itemBuilder: (context, index) {
                      final course = _courseModels[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CourseCard(course: course),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
