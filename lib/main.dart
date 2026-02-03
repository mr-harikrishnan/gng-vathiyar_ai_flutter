import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'package:vathiyar_ai_flutter/core/services/cognito-service.dart';
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';
import 'package:vathiyar_ai_flutter/core/utils/utils.dart';

import 'features/auth/ui/login-screen.dart';
import 'features/dashboard/ui/dashboard-screen.dart';
import 'features/my-courses/ui/my-courses.dart';
import 'features/course-details/ui/course-details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Amplify once
  await CognitoService.configure();

  runApp(const MainApp());
}

// APP ROOT

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Important: Use home instead of initialRoute
      home: const AuthGate(),

      routes: {
        "/login": (context) => const LoginPage(),
        "/dashboard": (context) => Dashboard(),
        "/mycourses": (context) => MyCoures(),
        "/course-details": (context) => Coursedetails(),
      },
    );
  }
}

// AUTH GATE

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final CognitoService _authService = CognitoService();
  String? idToken;
  bool _isLoading = true; // Track loading state
  bool _hasNavigated = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure widget tree is built first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuth();
    });
  }

  // AUTH FLOW

  Future<void> _initAuth() async {
    if (_hasNavigated) return; // Prevent multiple calls

    try {
      // 1. Read token from secure storage
      idToken = await readSecureData("idToken");
      Utils.longPrint("ID TOKEN", idToken ?? "");

      // 2. Check Amplify login state
      final isLoggedIn = await _authService.isLoggedIn();

      // 3. Validate token
      if (isLoggedIn) {
        final bool isValid = Utils.isValidToken(idToken ?? "");

        if (isValid) {
          await _goDashboard();
        } else {
          await _goLogin();
        }
      } else {
        await _goLogin();
      }
    } catch (e) {
      safePrint("Auth error: $e");
      // If any error, go to login
      await _goLogin();
    } finally {
      // Stop loading UI
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // NAVIGATION

  Future<void> _goLogin() async {
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;

    // Small delay to ensure context is ready
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  Future<void> _goDashboard() async {
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;

    // Small delay to ensure context is ready
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed("/dashboard");
    }
  }

  // UI

  @override
  Widget build(BuildContext context) {
    // Show loader until auth check finishes
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Fallback UI (should never stay here)
    return const Scaffold(body: Center(child: Text("Redirecting...")));
  }
}
