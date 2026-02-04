// lib/features/assigned-courses/assigned-courses.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-languages/get-languages-api.dart';
import 'package:vathiyar_ai_flutter/api/get-categories/get-categories_api.dart';
import 'package:vathiyar_ai_flutter/api/get-my-courses/get-my-courses-api.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/widgets/course-card.dart';
import 'package:vathiyar_ai_flutter/widgets/drop-down.dart';
import 'package:vathiyar_ai_flutter/widgets/horizontal-tab-bar.dart';
import 'package:vathiyar_ai_flutter/widgets/search-bar.dart';

class AssignedCourses extends StatefulWidget {
  const AssignedCourses({super.key});

  @override
  State<AssignedCourses> createState() => AssignedCoursesState();
}

class AssignedCoursesState extends State<AssignedCourses> {
  // Lists
  List<String> _languages = ["All Languages"];
  List<String> _categories = [];
  List<CourseModel> _courseModels = [];

  // Selected values
  String _selectedLanguage = "All Languages";
  String? _selectedCategory;

  // Maps
  Map<String, String> _languageMap = {};
  Map<String, String> _categoriesMap = {};

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

  // Load all data
  Future<void> _loadInitialData() async {
    await _loadLanguages();
    await _loadCategories();
    await _loadCourses();
  }

  // Load languages
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

  // Load categories
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

  // Load assigned courses
  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
    });

    // Language code
    String? langParam;
    if (_selectedLanguage != "All Languages") {
      langParam = _languageMap[_selectedLanguage];
    }

    // Category ID
    String? categoryParam;
    if (_selectedCategory != null) {
      categoryParam = _categoriesMap[_selectedCategory];
    }

    // Search text
    String? searchParam;
    if (_searchQuery.isNotEmpty) {
      searchParam = _searchQuery;
    }

    try {
      final result = await GetMyCoursesApiService.getMyCourses(
        enrollType: "ASSIGNED", // Only for Assigned screen
        status: "NOT_STARTED",
        categoryId: categoryParam,
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

  // Language change
  void _onLanguageChanged(String? newValue) {
    if (newValue == null) return;

    if (newValue == _selectedLanguage) return;

    setState(() {
      _selectedLanguage = newValue;
    });

    _loadCourses();
  }

  // Category tab change
  void _onCategoryChanged(int index) {
    if (_selectedCategory == _categories[index]) return;
    if (index < 0 || index >= _categories.length) return;

    setState(() {
      _selectedCategory = _categories[index];
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
      color: AppColors.secondary,
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

          // Category tabs
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
