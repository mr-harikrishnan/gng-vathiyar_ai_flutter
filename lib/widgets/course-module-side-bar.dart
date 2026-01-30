import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-course-module/get-course-module-api.dart';

class CourseModuleSideBar extends StatefulWidget {
  final String courseTitle;

  // Receive sections from CourseDetails
  final List<SectionModel> sections;

  const CourseModuleSideBar({
    super.key,
    required this.courseTitle,
    required this.sections,
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
            // Header
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

            // Modules List from API
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.sections.length,
                itemBuilder: (context, index) {
                  final section = widget.sections[index];

                  return _buildExpandableModule(
                    title: section.title,
                    children: section.topics.map((topic) {
                      return _buildSubModuleItem(
                        title: topic.title,
                        isCompleted: topic.isCompleted,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

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
              },
      ),
    );
  }
}
