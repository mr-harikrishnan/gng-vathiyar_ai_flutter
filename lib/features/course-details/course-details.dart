import 'package:flutter/material.dart';

class Coursedetails extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  const Coursedetails({super.key, required this.courseId, required this.courseTitle});

  @override
  State<Coursedetails> createState() => CoursedetailsState();
}

class CoursedetailsState extends State<Coursedetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.courseTitle)),
      body: const Center(child: Text("Course Details Content Here")),
    );
  }
}
