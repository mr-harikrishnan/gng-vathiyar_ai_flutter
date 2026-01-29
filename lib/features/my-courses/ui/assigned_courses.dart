// lib/features/assigned-courses/assigned_courses.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-languages/get-languages_api.dart';
import 'package:vathiyar_ai_flutter/api/my-courses/assigned_courses/get_categories_api.dart';
import 'package:vathiyar_ai_flutter/api/my-courses/in_progress/in_progress_api.dart';
import 'package:vathiyar_ai_flutter/widgets/course_card.dart';
import 'package:vathiyar_ai_flutter/widgets/drop_down.dart';
import 'package:vathiyar_ai_flutter/widgets/horizontal_tab_bar.dart';
import 'package:vathiyar_ai_flutter/widgets/search-bar.dart';

class AssignedCourses extends StatefulWidget {
  const AssignedCourses({super.key});

  @override
  State<AssignedCourses> createState() => AssignedCoursesState();
}

class AssignedCoursesState extends State<AssignedCourses> {
  //Data

  List<String> _languages = ["All Languages"];

  List<String> _categories = [];

  List<CourseModel> _courseModels = [];

  // Selected filters

  String? _selectedCategory;

  String _selectedLanguage = "All Languages";

  // Naps
  Map<String, String> _languageMap = {};

  Map<String, String> _categoriesMap = {};

  // Search text
  String _searchQuery = "";

  // Loading flags
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

  // INITIAL LOAD

  Future<void> _loadInitialData() async {
    await _loadLanguages();
    await _loadCategories();
    await _loadCourses();
  }

  // LOAD LANGUAGES

  Future<void> _loadLanguages() async {
    try {
      final result = await GetlanguagesApiService.getLanguages();

      _languageMap = {for (var e in result) e.name: e.code};

      setState(() {
        _languages = ["All Languages", ..._languageMap.keys];
      });
    } catch (e) {
      debugPrint("API Error (Languages): $e");
    }
  }

  // LOAD CATEGORIES

  Future<void> _loadCategories() async {
    try {
      final result = await GetCategoriesApiService.getCategories();

      _categoriesMap = {for (var e in result) e.name: e.id};

      setState(() {
        _categories = _categoriesMap.keys.toList();
        _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
      });
    } catch (e) {
      debugPrint("API Error (Categories): $e");
    }
  }

  // LOAD COURSES

  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
    });

    String? langParam;
    if (_selectedLanguage != "All Languages") {
      langParam = _languageMap[_selectedLanguage];
    }

    String? categoryParam;
    if (_selectedCategory != null) {
      categoryParam = _categoriesMap[_selectedCategory];
      print("Category Param: $categoryParam");
    }

    String? searchParam;
    if (_searchQuery.isNotEmpty) {
      searchParam = _searchQuery;
    }

    try {
      final result = await GetMyCoursesApiService.getMyCourses(
        status: "NOT_STARTED",
        lang: langParam,
        categoryId: categoryParam,
        searchKey: searchParam,
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

  // DROPDOWN CHANGE

  void _onLanguageChanged(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedLanguage = newValue;
    });

    // Reload courses
    _loadCourses();
  }

  // TAB CHANGE

  void _onCategoryChanged(int index) {
    if (index < 0 || index >= _categories.length) return;

    setState(() {
      _selectedCategory = _categories[index];
      print("Selected Category: $_selectedCategory");
    });

    // Reload courses
    _loadCourses();
  }

  // SEARCH WITH DEBOUNCE

  void _onSearchChanged(String text) {
    _searchQuery = text;

    // Cancel old timer
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    // Wait 500ms before API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7F6),
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

          // Categories tabs
          if (_categories.isNotEmpty)
            HorizontalTabBar(tabs: _categories, onChanged: _onCategoryChanged),

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
