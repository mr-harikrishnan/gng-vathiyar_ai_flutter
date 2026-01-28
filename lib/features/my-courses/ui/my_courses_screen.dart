import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/widgets/app_drawer.dart';
import 'package:vathiyar_ai_flutter/widgets/drop_down.dart';

class MyCoures extends StatefulWidget {
  const MyCoures({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyCoursesScreenState();
  }
}

class MyCoursesScreenState extends State<MyCoures> {
  final List<String> _languages = [
    'All Languages',
    'English',
    'Tamil',
    'Hindi',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F6),
        title: Text(
          "My Courses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "In-Progress",
              style: TextStyle(fontSize: 23),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 6),
            Dropdown(
              languages: _languages,
              onChanged: (String? newValue) {
                setState(() {});
                print('Selected language: $newValue');
              },
            ),
          ],
        ),
      ),
    );
  }
}
