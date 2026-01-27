import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/widgets/app_drawer.dart';
import 'package:vathiyar_ai_flutter/widgets/calendor.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F6),
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Image.asset(
            'assets/image1.png',
            width: 350,
            height: 350,
            fit: BoxFit.cover,
          ),
          Expanded(child: CustomCalendarPage()),
        ],
      ),
    );
  }
}
