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

  Future<void> _loadCourseModules() async {
    try {
      // Get ANY type from API
      final data = await GetCourseModuleApiService.getCourseModule(
        courseId: _courseId,
      );

      // Check JSON type
      if (data is Map<String, dynamic>) {
        setState(() {
          // Read sections directly from API JSON
          modulesData = data;
        });
      } else {
        throw Exception("Invalid API format");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        data: modulesData, // Send RAW JSON
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: CourseDetailsVideo(),
      ),
    );
  }
}
