import 'package:flutter/material.dart';

import 'package:vathiyar_ai_flutter/api/languages/language_service.dart';
import 'package:vathiyar_ai_flutter/api/languages/language_model.dart';

import 'package:vathiyar_ai_flutter/widgets/app_drawer.dart';
import 'package:vathiyar_ai_flutter/widgets/drop_down.dart';

class MyCoures extends StatefulWidget {
  const MyCoures({super.key});

  @override
  State<MyCoures> createState() {
    return MyCoursesScreenState();
  }
}

class MyCoursesScreenState extends State<MyCoures> {
  // Service
  final LanguageService _service =
      LanguageService();

  // Models
  List<LanguageModel> _languageModels = [];

  // Dropdown values
  List<String> _languages = [
    "All Languages"
  ];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // Call API when screen opens
    _loadLanguages();
  }

  // Load from API
  Future<void> _loadLanguages() async {
    try {
      final result =
          await _service.getLanguages();

      // Print full API data in console
      for (var lang in result) {
        print(
          "ID: ${lang.id}, Name: ${lang.name}, Code: ${lang.code}",
        );
      }

      setState(() {
        _languageModels = result;

        // Clear and add default
        _languages = ["All Languages"];

        // Add names to dropdown list
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F6),
        title: const Text(
          "My Courses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "In-Progress",
              style: TextStyle(fontSize: 23),
            ),
            const SizedBox(height: 6),
            Dropdown(
              languages: _languages,
              onChanged: (String? newValue) {
                print(
                  "Selected language: $newValue",
                );
              },
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
