import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/widgets/app_drawer.dart';

class MyCoures extends StatefulWidget {
  const MyCoures({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyCoursesScreenState();
  }
}

class MyCoursesScreenState extends State<MyCoures> {
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
      drawer:AppDrawer(),
      
    );
  }
}
