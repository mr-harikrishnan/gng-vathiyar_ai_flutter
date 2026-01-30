import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito-service.dart';
import 'package:vathiyar_ai_flutter/core/storage/get-x-controller/user-controller.dart';
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';
import 'package:vathiyar_ai_flutter/features/auth/ui/login-screen.dart';
import 'package:vathiyar_ai_flutter/features/dashboard/ui/dashboard-screen.dart';
import 'package:vathiyar_ai_flutter/features/my-courses/ui/my-courses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Amplify before app starts
  await CognitoService.configure();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Put GetX controller once
      initialBinding: BindingsBuilder(() {
        Get.put(GetxUserController(), permanent: true);
      }),

      routes: {
        "/": (context) => const AuthGate(), // This checks token
        "/login": (context) => const LoginPage(),
        "/dashboard": (context) => Dashboard(),
        "/mycourses": (context) => MyCoures(),
      },

      initialRoute: "/",
    );
  }
}


class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      // Read token from secure storage
      final accessToken = await readSecureData("accessToken");

      // If token is missing -> go login
      if (accessToken == null || accessToken.isEmpty) {
        _goLogin();
        return;
      }

      // Ask Amplify if session is still valid
      final session = await Amplify.Auth.fetchAuthSession();

      // If session is valid -> go dashboard
      if (session.isSignedIn) {
        _goDashboard();
      } else {
        _goLogin();
      }
    } catch (e) {
      // If any error -> go login
      _goLogin();
    }
  }

  void _goLogin() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void _goDashboard() {
    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading screen
    return const Scaffold(body: Center(child: SizedBox()));
  }
}
