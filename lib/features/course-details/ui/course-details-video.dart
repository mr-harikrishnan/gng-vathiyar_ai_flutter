import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/get-video-questions/get-video-questions-api.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/widgets/intro-des-container.dart';
import 'package:vathiyar_ai_flutter/widgets/video-player.dart';

class CourseDetailsVideo extends StatefulWidget {
  final String contentId;
  const CourseDetailsVideo({super.key, required this.contentId});

  @override
  State<StatefulWidget> createState() {
    return CourseDetailsVideoState();
  }
}

class CourseDetailsVideoState extends State<CourseDetailsVideo> {
  bool isCompleted = true;
  late String contentId;
  String? videoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    contentId = widget.contentId;
    
    _loadVideoDetails();
  }

  Future<void> _loadVideoDetails() async {
    try {
      
      final data = await GetVideoQuestions.getVideoQuestions(
        contentId: contentId,
      );
      
      

      if (data.isNotEmpty && data[0].url != null) {
        setState(() {
          videoUrl = data[0].url!;
          print("####################============ ${data[0].url!}");
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("API Error (Get video Data): $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // button
        Container(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted
                  ? AppColors.primary
                  : AppColors.greylight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              setState(() {
                isCompleted = true;
              });
            },
            child: Text(
              isCompleted ? "Completed" : "Mark As Completed",
              style: TextStyle(
                color: isCompleted ? Colors.white : AppColors.greylight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // video-content
        if (isLoading)
          const CircularProgressIndicator()
        else if (videoUrl != null)
          ChewieVideoPlayer(videoUrl: videoUrl!)
        else
          const Text("Video not available"),

        const SizedBox(height: 12),

        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Course Description",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const IntroDesContainer(),
        ),
      ],
    );
  }
}
