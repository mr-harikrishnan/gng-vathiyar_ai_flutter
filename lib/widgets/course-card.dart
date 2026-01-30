import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/api/my-courses/my-courses-api.dart';

class CourseCard extends StatefulWidget {
  final CourseModel course;
  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => CourseCardState();
}

class CourseCardState extends State<CourseCard> {
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return "${hours}Hr ${remainingMinutes}min";
  }

  String _formatUpdatedAt(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      const months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];
      final month = months[dateTime.month - 1];
      final day = dateTime.day;
      final year = dateTime.year;
      final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final ampm = dateTime.hour >= 12 ? "PM" : "AM";

      return "Last updated at $month ${day}th, $year $hour:$minute $ampm";
    } catch (e) {
      return "Last updated at $dateString";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Course tapped: ${widget.course.id}");
   
        Navigator.pushNamed(
          context,
          '/course-details',
          arguments: {'courseId': widget.course.id, 'courseTitle': widget.course.title},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    "https://cdn.appbuild.pro/${widget.course.thumbnailImage}",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Show loader while image loads
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    // Show error icon if image fails
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.error));
                    },
                  ),

                  // Time badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(widget.course.courseDuration),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              widget.course.subTitle,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // Progress + last updated
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pie_chart,
                      size: 16,
                      color: Color(0xFF009688),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${widget.course.completionPercent}% COMPLETED",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  _formatUpdatedAt(widget.course.updatedAt),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
