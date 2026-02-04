import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-course-module/get-course-module-api.dart';
import 'package:vathiyar_ai_flutter/features/course-details/ui/course-details-video.dart';
import 'package:vathiyar_ai_flutter/widgets/course-module-side-bar.dart';

class Coursedetails extends StatefulWidget {
  const Coursedetails({super.key});

  @override
  State<Coursedetails> createState() => CoursedetailsState();
}

class CoursedetailsState extends State<Coursedetails> {
  String _courseId = "";
  String _courseTitle = "";
  dynamic modulesData;
  String currentContent = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //get courseId and courseTitle from arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && _courseId.isEmpty) {
      _courseId = args["courseId"] ?? "";
      _courseTitle = args["courseTitle"] ?? "";
      _loadCourseModules();
    }
  }

  //get modules data
  Future<void> _loadCourseModules() async {
    try {
      final data = await GetCourseModuleApiService.getCourseModule(
        courseId: _courseId,
      );

      if (data is Map<String, dynamic>) {
        setState(() {
          modulesData = data;
          final initialContentId = _findInitialContentId(data);
          if (initialContentId.isNotEmpty) {
            _onContentChange(initialContentId);
            print("content id ====== $initialContentId");
          }
        });
      } else {
        throw Exception("Invalid API format");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }

  //get current content
  String _findInitialContentId(Map<String, dynamic> data) {
    if (data["isIntroCompleted"] != true) {
      return data["introduction"]?["contentIds"]?[0]?["_id"] ?? "";
    }
    if (data["isPreTestCompleted"] != true) {
      return data["preTestId"]?.toString() ?? "";
    }
    if (data["sections"] != null) {
      for (var section in data["sections"]) {
        if (section["topics"] != null) {
          for (var topic in section["topics"]) {
            if (topic["isTopicCompleted"] != true) {
              return topic?["topicId"]?["contentIds"]?[0]?["_id"] ?? "";
            }
            if (topic["quizId"] != null &&
                topic["isTopicQuizCompleted"] != true) {
              return topic["quizId"].toString();
            }
          }
        }
      }
    }
    return data["introduction"]?["contentIds"]?[0]?["_id"] ?? "";
  }

  void _onContentChange(String contentId) {
    setState(() {
      currentContent = contentId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //Content side bar
      appBar: AppBar(
        title: Text(_courseTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: CourseModuleSideBar(
        courseTitle: _courseTitle,
        data: modulesData,
        onContentChange: _onContentChange,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          //Course details Video Screen
          child: CourseDetailsVideo(contentId: currentContent),
        ),
      ),
    );
  }
}
