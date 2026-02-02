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
                  // INTRO
                  _buildModuleItem(
                    title: "Introduction to the Session",
                    isCompleted: isIntroCompleted,
                  ),

                  // PRE-TEST
                  _buildModuleItem(
                    title: "Pre-Test",
                    isCompleted: isPreTestCompleted,
                  ),

                  // SECTIONS
                  ...sections.map((section) {
                    return _buildExpandableModule(
                      title: section.title,
                      children: section.topics.map((topic) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------- TOPIC ROW --------
                            // Always open, never locked
                            _buildSubModuleItem(
                              title: topic.title,
                              isCompleted: topic.isCompleted,
                              isLocked: false,
                              onTap: () {
                                Navigator.pop(context);
                                print("Open topic: ${topic.title}");
                              },
                            ),

                            // -------- QUIZ ROW --------
                            // Show only if quiz exists
                            if (topic.quizId != null)
                              _buildSubModuleItem(
                                title: "Quiz",
                                isCompleted: topic.isQuizCompleted,
                                isLocked: topic.isCompleted == false,
                                onTap: () {
                                  if (topic.isCompleted) {
                                    Navigator.pop(context);
                                    print("Open quiz: ${topic.quizId}");
                                  }
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
                  ),

                  // CERTIFICATE
                  _buildModuleItem(
                    title: "Certificate",
                    isCompleted: false,
                    isLocked: true,
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
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: _getIcon(isCompleted, isLocked),
      onTap: isLocked ? null : () {},
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
        children: children,
      ),
    );
  }

  Widget _buildSubModuleItem({
    required String title,
    required bool isCompleted,
    required bool isLocked,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: _getIcon(isCompleted, isLocked),
        onTap: isLocked ? null : onTap,
      ),
    );
  }


  Widget _getIcon(bool isCompleted, bool isLocked) {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 18);
    }

    if (isLocked) {
      return const Icon(Icons.lock_outline, size: 18);
    }

    return const SizedBox.shrink();
  }
}
