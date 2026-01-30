// FIX: SHOW QUIZ ONLY IF API HAS quizId
// Module 5 topics have NO quizId, so UI must hide Quiz row

import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-course-module/get-course-module-api.dart';

class CourseModuleSideBar extends StatelessWidget {
  final String courseTitle;
  final List<SectionModel> sections;
  final bool isIntroCompleted;
  final bool isPreTestCompleted;

  const CourseModuleSideBar({
    super.key,
    required this.courseTitle,
    required this.sections,
    this.isIntroCompleted = false,
    this.isPreTestCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Modules",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // INTRO
                  _buildModuleItem(
                    title: "Introduction to the Session",
                    isCompleted: isIntroCompleted,
                    onTap: () {
                      Navigator.pop(context);
                      print("Intro tapped");
                    },
                  ),

                  // PRE TEST
                  _buildModuleItem(
                    title: "Pre-Test",
                    isCompleted: isPreTestCompleted,
                    onTap: () {
                      Navigator.pop(context);
                      print("Pre-Test tapped");
                    },
                  ),

                  // SECTIONS
                  ...sections.map((section) {
                    return _buildExpandableModule(
                      title: section.title,
                      children: section.topics.map((topic) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TOPIC ROW
                            _buildSubModuleItem(
                              title: topic.title,
                              isCompleted: topic.isCompleted,
                              onTap: () {
                                Navigator.pop(context);
                                print("Open topic: ${topic.title}");
                              },
                            ),

                            // QUIZ ROW (ONLY IF EXISTS IN API)
                            if (topic.quizId != null &&
                                topic.quizId!.isNotEmpty)
                              _buildSubModuleItem(
                                title: "Quiz",
                                isCompleted: topic.isQuizCompleted,

                                // Lock quiz until topic done
                                isLocked: topic.isCompleted == false,

                                textColor: const Color(0xFF006A63),
                                onTap: () {
                                  Navigator.pop(context);
                                  print("Open quiz: ${topic.quizId}");
                                },
                              ),
                          ],
                        );
                      }).toList(),
                    );
                  }).toList(),

                  // SUMMARY
                  _buildModuleItem(
                    title: "Summary",
                    isCompleted: false,
                    isLocked: true,
                    onTap: () {
                      Navigator.pop(context);
                      print("Summary tapped");
                    },
                  ),

                  // CERTIFICATE
                  _buildModuleItem(
                    title: "Certificate",
                    isCompleted: false,
                    isLocked: true,
                    onTap: () {
                      Navigator.pop(context);
                      print("Certificate tapped");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _buildModuleItem({
    required String title,
    required bool isCompleted,
    bool isLocked = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: isLocked
          ? const Icon(Icons.lock_outline, size: 18)
          : isCompleted
          ? const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 20)
          : null,
      onTap: isLocked ? null : onTap,
    );
  }

  Widget _buildExpandableModule({
    required String title,
    required List<Widget> children,
  }) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        initiallyExpanded: false,
        children: children,
      ),
    );
  }

  Widget _buildSubModuleItem({
    required String title,
    required bool isCompleted,
    bool isLocked = false,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 14, color: textColor)),
        trailing: isLocked
            ? const Icon(Icons.lock_outline, size: 18)
            : isCompleted
            ? const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 18)
            : null,
        onTap: isLocked ? null : onTap,
      ),
    );
  }
}
