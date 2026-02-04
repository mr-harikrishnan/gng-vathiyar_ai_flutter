import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';

class CourseModuleSideBar extends StatefulWidget {
  final String courseTitle;
  final dynamic data;

  const CourseModuleSideBar({
    super.key,
    required this.courseTitle,
    required this.data,
  });

  @override
  State<CourseModuleSideBar> createState() => _CourseModuleSideBarState();
}

class _CourseModuleSideBarState extends State<CourseModuleSideBar> {
  late Map<String, dynamic> datas;

  int rowNumber = 0;
  int _lastDoneRow = 0;

  @override
  void initState() {
    super.initState();
    datas = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    // // Reset on every build
    rowNumber = 0;
    _lastDoneRow = 0;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _header(),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                children: [
                  _simpleRow(
                    "Introduction to the Session",
                    datas["isIntroCompleted"] == true,
                    datas["introduction"]?["contentIds"]?[0]?["_id"] ??
                        "no data",
                  ),

                  const Divider(height: 1),

                  _simpleRow(
                    "Pre-Test",
                    datas["isPreTestCompleted"] == true,
                    datas["preTestId"] != null
                        ? datas["preTestId"].toString()
                        : "no data",
                  ),

                  const Divider(height: 1),

                  for (var section in datas["sections"] ?? []) ...[
                    _buildSection(section),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  HEADER
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Modules",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  //  ICON LOGIC
  Icon _getIcon(bool done, int thisRow) {
    if (done) {
      _lastDoneRow = thisRow;
      return const Icon(Icons.check_circle, color: AppColors.primary);
    }

    if (thisRow == _lastDoneRow + 1) {
      return const Icon(Icons.check_circle, color: Colors.transparent);
    }

    return const Icon(Icons.lock, color: AppColors.greylight);
  }

  //  SECTION
  Widget _buildSection(Map<String, dynamic> section) {
    final List topics = section["topics"] ?? [];

    return ExpansionTile(
      title: Text(
        section["title"] ?? "Module",
        style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.greylight),
      ),
      children: [
        for (var topic in topics) ...[
          _topicRow(
            topic["title"] ?? "Topic",
            topic["isTopicCompleted"] == true,
            topic?["topicId"]?["contentIds"]?[0]?["_id"] ?? "no data",
          ),
          if (topic["quizId"] != null)
            _quizRow(
              topic["title"] ?? "Topic",
              topic["isTopicQuizCompleted"] == true,
              topic["quizId"].toString(),
            ),
        ],
      ],
    );
  }

  //  TOP ROW
  Widget _simpleRow(String title, bool done, String contentId) {
    rowNumber += 1;
    final int thisRow = rowNumber;

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.greylight),
      ),
      trailing: _getIcon(done, thisRow),
      onTap: () {
        print("Clicked on '$title'");
        print("Content ID: $contentId");
      },
    );
  }

  //  TOPIC ROW
  Widget _topicRow(String title, bool done, String contentId) {
    rowNumber += 1;
    final int thisRow = rowNumber;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.greylight),
      ),
      trailing: _getIcon(done, thisRow),
      onTap: () {
        print("Clicked on TOPIC: '$title'");
        print("Content ID: $contentId");
      },
    );
  }

  //  QUIZ ROW
  Widget _quizRow(String topicTitle, bool done, String quizId) {
    rowNumber += 1;
    final int thisRow = rowNumber;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      title: const Text(
        "Quiz",
        style: TextStyle(color: AppColors.greylight),
      ),
      trailing: _getIcon(done, thisRow),
      onTap: () {
        print("Clicked on QUIZ for: $topicTitle");
        print("Quiz ID: $quizId");
      },
    );
  }
}
