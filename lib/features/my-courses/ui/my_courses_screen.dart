import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-languages/get-languages_api.dart';
import 'package:vathiyar_ai_flutter/api/my-courses/my-courses_api.dart';
import 'package:vathiyar_ai_flutter/widgets/app_drawer.dart';
import 'package:vathiyar_ai_flutter/widgets/course_card.dart';
import 'package:vathiyar_ai_flutter/widgets/drop_down.dart';
import 'package:vathiyar_ai_flutter/widgets/search-bar.dart';

class MyCoures extends StatefulWidget {
  const MyCoures({super.key});

  @override
  State<MyCoures> createState() => MyCoursesScreenState();
}

class MyCoursesScreenState extends State<MyCoures> {
  // Data list
  List<CourseModel> _courseModels = [];

  // Dropdown values
  List<String> _languages = ["All Languages"];
  String _selectedLanguage = "All Languages";

  // Search text
  String _searchQuery = "";

  // Loading flags
  bool _loadingLanguages = true;
  bool _loadingCourses = true;

  // Debounce for search
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

  Future<void> _loadInitialData() async {
    await _loadLanguages();
    await _loadCourses();
  }

  // ----------------------------
  // LOAD LANGUAGES
  // ----------------------------
  Future<void> _loadLanguages() async {
    setState(() {
      _loadingLanguages = true;
    });

    try {
      final result = await GetlanguagesApiService.getLanguages();

      setState(() {
        _languages = ["All Languages", ...result.map((e) => e.name)];
        _loadingLanguages = false;
      });
    } catch (e) {
      print("API Error (Languages): $e");
      setState(() {
        _loadingLanguages = false;
      });
    }
  }

  // ----------------------------
  // LOAD COURSES
  // ----------------------------
  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
    });

    // Send lang only if dropdown is not "All Languages"
    String? langParam;
    if (_selectedLanguage != "All Languages") {
      langParam = _selectedLanguage;
    }

    // Send search only if user typed
    String? searchParam;
    if (_searchQuery.isNotEmpty) {
      searchParam = _searchQuery;
    }

    try {
      final result = await GetMyCoursesApiService.getMyCourses(
        status: "IN_PROGRESS",
        lang: langParam, // Language filter
        searchKey: searchParam, // Search filter
      );

      setState(() {
        _courseModels = result;
        _loadingCourses = false;
      });
    } catch (e) {
      print("API Error (Courses): $e");
      setState(() {
        _loadingCourses = false;
      });
    }
  }

  // ----------------------------
  // DROPDOWN CHANGE
  // ----------------------------
  void _onLanguageChanged(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedLanguage = newValue;
    });

    _loadCourses(); // Reload courses when language changes
  }

  // ----------------------------
  // SEARCH WITH DEBOUNCE
  // ----------------------------
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
    bool isLoading = _loadingLanguages || _loadingCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Courses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: const Color(0xFFF5F7F6),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "In-Progress",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Language dropdown
            Dropdown(
              value: _selectedLanguage,
              languages: _languages,
              loading: _loadingLanguages,
              onChanged: _onLanguageChanged,
            ),
            const SizedBox(height: 10),

            // Search bar
            SearchBarWidget(loading: isLoading, onChanged: _onSearchChanged),
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
      ),
    );
  }
}
