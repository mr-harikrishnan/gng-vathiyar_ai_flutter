import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/widgets/course-module-side-bar.dart';

class Coursedetails extends StatefulWidget {
  const Coursedetails({super.key});

  @override
  State<Coursedetails> createState() => CoursedetailsState();
}

class CoursedetailsState extends State<Coursedetails> {
  String _courseId = "";
  String _courseTitle = "";
  Map<String, dynamic>? _courseData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _courseId = args["courseId"] ?? "";
      _courseTitle = args["courseTitle"] ?? "";
      _courseData = args["courseData"];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("_courseId : $_courseId");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(_courseTitle)),
      endDrawer: CourseModuleSideBar(
        courseTitle: _courseTitle,
        courseData: _courseData,
      ),
      body: Column(
        children: [Expanded(child: Center(child: Text('Course Content')))],
      ),
    );
  }
}
