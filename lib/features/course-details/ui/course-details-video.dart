import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/widgets/intro-des-container.dart';
import 'package:vathiyar_ai_flutter/widgets/video-player.dart';

class CourseDetailsVideo extends StatefulWidget {
  const CourseDetailsVideo({super.key});

  @override
  State<StatefulWidget> createState() {
    return CourseDetailsVideoState();
  }
}

class CourseDetailsVideoState extends State<CourseDetailsVideo> {
  bool isCompleted = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //button
        Container(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted == true
                  ? AppColors.primary
                  : AppColors.greylight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: (() => print("btn pressed")),
            child: Text(
              isCompleted == true ? "Completed" : "Mark As Completed",
              style: TextStyle(
                color: isCompleted == true
                    ? Colors.white
                    : AppColors.greylight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        //video-content
        ChewieVideoPlayer(
          videoUrl:
              'https://cdn.appbuild.pro/course/content/669ba10e8be13680e0b6478f/669ba10e8be13680e0b6478f.m3u8',
        ),
        SizedBox(height: 12),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Course Description",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),

          child: IntroDesContainer(),
        ),
      ],
    );
  }
}
