import 'package:flutter/material.dart';

class IntroDesContainer extends StatefulWidget {
  const IntroDesContainer({super.key});

  @override
  State<StatefulWidget> createState() {
    return IntroDesContainerState();
  }
}

class IntroDesContainerState extends State<IntroDesContainer> {
  String duration = formatCourseDuration(50);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "This course will help the learners to understand the importance of organizing ‘No Bag Day’ at school. After finishing this course learners will also be able to plan and organize 'No Bag Day' at school. ",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        SizedBox(height: 12),
        Container(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFEDF8F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              duration,
              style: TextStyle(
                color: Color.fromARGB(255, 138, 137, 137),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String formatCourseDuration(int totalMinutes) {
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;

  return "Course duration: ${hours}Hr ${minutes}min";
}
