import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-course-module/get-course-module-api.dart';
import 'package:vathiyar_ai_flutter/widgets/course-module-side-bar.dart';

class Coursedetails extends StatefulWidget {
  const Coursedetails({super.key});

  @override
  State<Coursedetails> createState() => CoursedetailsState();
}

class CoursedetailsState extends State<Coursedetails> {
  String _courseId = "";
  String _courseTitle = "";

  // Store sections here
  List<SectionModel> _sections = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get route args only once
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && _courseId.isEmpty) {
      _courseId = args["courseId"] ?? "";
      _courseTitle = args["courseTitle"] ?? "";

      // Call API after getting courseId
      _loadCourseModules();
    }
  }

  Future<void> _loadCourseModules() async {
    try {
      setState(() {
        _loading = true;
      });

      // Call API
      final courseModel = await GetCourseModuleApiService.getCourseModule(
        courseId: _courseId,
      );

      // Save sections from API
      setState(() {
        _sections = courseModel.sections;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });

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
              // Open right side drawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: CourseModuleSideBar(
        courseTitle: _courseTitle,

        // Pass sections to sidebar
        sections: _sections,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Course Content'),
            ),
          ),
        ],
      ),
    );
  }
}
