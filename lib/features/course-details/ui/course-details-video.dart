import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/widgets/video-player.dart';
import 'package:video_player/video_player.dart';

class CourseDetailsVideo extends StatefulWidget {
  const CourseDetailsVideo({super.key});

  @override
  State<StatefulWidget> createState() {
    return CourseDetailsVideoState();
  }
}

class CourseDetailsVideoState extends State<CourseDetailsVideo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //button
        Container(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF006A63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: (() => print("btn pressed")),
            child: Text(
              "Mark As Completed",
              style: TextStyle(
                color: Colors.white,
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
      ],
    );
  }
}
