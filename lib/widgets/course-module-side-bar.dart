import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-course-module/get-course-module-api.dart';

class CourseModuleSideBar extends StatefulWidget {
  final String courseTitle;

  // Sections from API
  final List<SectionModel> sections;

  // Flags from API (pass later from CourseDetails if needed)
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
  State<StatefulWidget> createState() {
    return CourseModuleSideBarState();
  }
}

class CourseModuleSideBarState extends State<CourseModuleSideBar> {
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
                    'Modules',
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
                    isCompleted: widget.isIntroCompleted,
                    onTap: () {
                      Navigator.pop(context);
                      print("Intro tapped");
                    },
                  ),

                  // PRE TEST
                  _buildModuleItem(
                    title: "Pre-Test",
                    isCompleted: widget.isPreTestCompleted,
                    onTap: () {
                      Navigator.pop(context);
                      print("Pre-Test tapped");
                    },
                  ),

                  // SECTIONS FROM API
                  ...widget.sections.map((section) {
                    return _buildExpandableModule(
                      title: section.title,
                      children: section.topics.map((topic) {
                        return Column(
                          children: [
                            // TOPIC
                            _buildSubModuleItem(
                              title: topic.title,
                              isCompleted: topic.isCompleted,
                            ),

                            // QUIZ ROW
                            _buildSubModuleItem(
                              title: "Quiz",
                              isCompleted: false,
                              isLocked: topic.isCompleted == false,
                              textColor: const Color(0xFF006A63),
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

  // ---------------- UI HELPERS ----------------

  Widget _buildModuleItem({
    required String title,
    required bool isCompleted,
    bool isLocked = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
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
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: textColor ?? Colors.black),
        ),
        trailing: isLocked
            ? const Icon(Icons.lock_outline, size: 18)
            : isCompleted
            ? const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 18)
            : null,
        onTap: isLocked
            ? null
            : () {
                Navigator.pop(context);
                print("Tapped: $title");
              },
      ),
    );
  }
}
