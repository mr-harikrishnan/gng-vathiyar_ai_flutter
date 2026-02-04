import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/features/my-courses/ui/assigned-courses.dart';
import 'package:vathiyar_ai_flutter/features/my-courses/ui/in-progress.dart';
import 'package:vathiyar_ai_flutter/widgets/app-drawer.dart';

class MyCoures extends StatefulWidget {
  const MyCoures({super.key});

  @override
  State<MyCoures> createState() => MyCoursesScreenState();
}

class MyCoursesScreenState extends State<MyCoures> {
  var screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Courses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: AppColors.secondary,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: screenIndex == 0
                          ? AppColors.primary
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        screenIndex = 0;
                      });
                    },
                    child: Text(
                      "In Progress",
                      style: TextStyle(
                        color: screenIndex == 0
                            ? Colors.white
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: screenIndex == 1
                          ? AppColors.primary
                          : Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        screenIndex = 1;
                      });
                    },
                    child: Text(
                      "Assigned Courses",
                      style: TextStyle(
                        color: screenIndex == 1
                            ? Colors.white
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (screenIndex == 0)
              const Expanded(child: InProgress())
            else if (screenIndex == 1)
              const Expanded(child: AssignedCourses()),
          ],
        ),
      ),
    );
  }
}
