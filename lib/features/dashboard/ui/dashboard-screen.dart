import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/widgets/app-drawer.dart';

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
      
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: AppColors.secondary,
        child: Center(child: Text("Dashboard"))),
    );
  }
}
