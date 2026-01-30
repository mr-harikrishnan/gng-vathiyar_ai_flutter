
import 'package:flutter/material.dart';

class Coursedetails extends StatefulWidget {
  const Coursedetails({super.key}); // <-- remove required params

  @override
  State<Coursedetails> createState() => CoursedetailsState();
}

class CoursedetailsState extends State<Coursedetails> {
  String _courseId = "";
  String _courseTitle = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Read arguments from Navigator
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _courseId = args["courseId"] ?? "";
      _courseTitle = args["courseTitle"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_courseTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Course ID: $_courseId"),
            const SizedBox(height: 10),
            Text("Course Title: $_courseTitle"),
          ],
        ),
      ),
    );
  }
}
