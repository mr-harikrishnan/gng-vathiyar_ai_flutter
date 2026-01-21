import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito_service.dart';
import 'package:vathiyar_ai_flutter/features/auth/ui/login_screen.dart';
import 'package:vathiyar_ai_flutter/features/dashboard/ui/dashboard_screen.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    // Setup Amplify once
    CognitoService.configure();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/" : (context) => const LoginPage(),
        "/dashboard" : (context) => Dashboard()
      },
      initialRoute: "/",
    );
  }
}
