import 'package:flutter/material.dart';

class CourseModuleSideBar extends StatefulWidget {
  final String courseTitle;
  final Map<String, dynamic>? courseData;
  
  const CourseModuleSideBar({
    super.key,
    required this.courseTitle,
    this.courseData,
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

            // Modules List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildModuleItem(
                    title: 'Introduction to the Session',
                    isCompleted: true,
                    onTap: () {
                      Navigator.pop(context);
                      print('Introduction tapped');
                    },
                  ),
                  _buildModuleItem(
                    title: 'Pre-Test',
                    isCompleted: true,
                    onTap: () {
                      Navigator.pop(context);
                      print('Pre-Test tapped');
                    },
                  ),
                  _buildExpandableModule(
                    title: 'Module 1: Let\'s Identify the challenges',
                    children: [
                      _buildSubModuleItem(
                        title: 'Identifying the Challenges in School',
                        isCompleted: true,
                      ),
                      _buildSubModuleItem(
                        title: 'Quiz',
                        isCompleted: true,
                      ),
                      _buildSubModuleItem(
                        title: 'Possible Challenges & Solutions',
                        isCompleted: false,
                        textColor: Color(0xFF006A63),
                      ),
                      _buildSubModuleItem(
                        title: 'Quiz',
                        isCompleted: false,
                        isLocked: true,
                      ),
                    ],
                  ),
                  _buildExpandableModule(
                    title: 'Module 2: Concept of No Bag Day and Policy Connect',
                    children: [
                      _buildSubModuleItem(
                        title: 'No Bag Day and Policy Connect',
                        isCompleted: false,
                        isLocked: true,
                      ),
                      _buildSubModuleItem(
                        title: 'Quiz',
                        isCompleted: false,
                        isLocked: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleItem({
    required String title,
    required bool isCompleted,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 20)
          : null,
      onTap: onTap,
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
        initiallyExpanded: true,
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
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? Colors.black,
          ),
        ),
        trailing: isLocked
            ? const Icon(Icons.lock_outline, color: Colors.black, size: 18)
            : isCompleted
                ? const Icon(Icons.check_circle, color: Color(0xFF006A63), size: 18)
                : null,
        onTap: isLocked
            ? null
            : () {
                Navigator.pop(context);
                print('$title tapped');
              },
      ),
    );
  }
}