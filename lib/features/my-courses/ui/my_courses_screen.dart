// lib/features/my-courses/ui/my_courses.dart

import 'package:flutter/material.dart';

import 'package:vathiyar_ai_flutter/api/get-languages/get-languages.dart';

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
  // Models
  List<LanguageModel> _languageModels = [];

  // Dropdown values
  List<String> _languages = ["All Languages"];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages(); // Call API when screen opens
  }

  // Load from API
  Future<void> _loadLanguages() async {
    try {
      final result = await ApiService.getLanguages();

      setState(() {
        _languageModels = result;

        // Reset list
        _languages = ["All Languages"];

        // Add API values
        for (var lang in _languageModels) {
          _languages.add(lang.name);
        }

        _loading = false;
      });
    } catch (e) {
      print("API Error: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  // Search filter
  void _onSearch(String text) {
    setState(() {
      _languages = ["All Languages"];

      for (var lang in _languageModels) {
        if (lang.name.toLowerCase().contains(text.toLowerCase())) {
          _languages.add(lang.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

            // Dropdown
            Dropdown(
              
              languages: _languages,
              loading: _loading,
              onChanged: (value) {
                print("Selected language: $value");
              },
            ),

            const SizedBox(height: 10),

            // Search bar
            SearchBarWidget(loading: _loading, onChanged: _onSearch),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: CourseCard(),
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
