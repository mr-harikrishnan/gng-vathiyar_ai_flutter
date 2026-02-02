import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito-service.dart';

import 'features/auth/ui/login-screen.dart';
import 'features/dashboard/ui/dashboard-screen.dart';
import 'features/my-courses/ui/my-courses.dart';
import 'features/course-details/course-details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Amplify once
  await CognitoService.configure();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const AuthGate(),
        "/login": (context) => const LoginPage(),
        "/dashboard": (context) => Dashboard(),
        "/mycourses": (context) => MyCoures(),
        "/course-details": (context) => Coursedetails(),
      },
    );
  }
}

// AUTH GATE (UI ONLY)

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final CognitoService _authService = CognitoService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Ask service if user is logged in
    final isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      _goDashboard();
    } else {
      _goLogin();
    }
  }

  void _goLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  void _goDashboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading UI
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
