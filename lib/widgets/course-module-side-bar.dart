import 'package:flutter/material.dart';

class CourseModuleSideBar extends StatefulWidget {
  final String courseTitle;
  final data;

  const CourseModuleSideBar({
    super.key,
    required this.courseTitle,
    required this.data,
  });

  @override
  State<CourseModuleSideBar> createState() => _CourseModuleSideBarState();
}

class _CourseModuleSideBarState extends State<CourseModuleSideBar> {
  var datas;

  @override
  void initState() {
    super.initState();
    datas = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Modules",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ---------------- LIST ----------------
            Expanded(
              child: ListView(
                children: [
                  _simpleRow(
                    "Introduction to the Session",
                    datas["isIntroCompleted"] == true ? true : false,
                  ),
                  const Divider(height: 1),

                  _simpleRow(
                    "Pre-Test",
                    datas["isPreTestCompleted"] == true ? true : false,
                  ),
                  const Divider(height: 1),
                  // Modules from API
                  for (var section in datas["sections"] ?? []) ...[
                    _buildSection(section),
                    const Divider(height: 1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// One module
Widget _buildSection(Map<String, dynamic> section) {
  final List topics = section["topics"] ?? [];

  return ExpansionTile(
    title: GestureDetector(
      onTap: () {
        // Print module title
        print("CLICKED MODULE: ${section["title"]}");
      },
      child: Text(
        section["title"] ?? "Module",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    children: [
      for (var topic in topics) ...[
        _topicRow(topic["title"] ?? "Topic", topic["isTopicCompleted"] == true),

        (topic["quizId"] != null)
            ? _quizRow(
                topic["title"] ?? "Topic",
                topic["isTopicQuizCompleted"] == true,
              )
            : const SizedBox.shrink(),
      ],
    ],
  );
}

// Top rows
Widget _simpleRow(String title, bool done) {
  return ListTile(
    title: Text(title),
    trailing: Icon(
      done ? Icons.check_circle : Icons.lock,
      color: done ? Color(0xFF006A63) : Colors.grey,
    ),
    onTap: () {
      // Print row text
      print("CLICKED: $title");
    },
  );
}

// Topic row
Widget _topicRow(String title, bool done) {
  return ListTile(
    contentPadding: const EdgeInsets.only(left: 32, right: 16),
    title: Text(title),
    trailing: Icon(
      done ? Icons.check_circle : Icons.lock,
      color: done ? Color(0xFF006A63) : Colors.grey,
      size: 20,
    ),
    onTap: () {
      // Print topic title
      print("CLICKED TOPIC: $title");
    },
  );
}

// Quiz row
Widget _quizRow(String topicTitle, bool done) {
  return ListTile(
    contentPadding: const EdgeInsets.only(left: 48, right: 16),
    title: const Text("Quiz"),
    trailing: Icon(
      done ? Icons.check_circle : Icons.lock,
      color: done ? Color(0xFF006A63) : Colors.grey,
      size: 20,
    ),
    onTap: () {
      // Print quiz under which topic
      print("CLICKED QUIZ FOR: $topicTitle");
    },
  );
}
