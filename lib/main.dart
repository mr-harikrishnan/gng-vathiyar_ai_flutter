import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito_service.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/userController.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/drawer_controller.dart'
    as my;
import 'package:vathiyar_ai_flutter/features/auth/ui/login_screen.dart';
import 'package:vathiyar_ai_flutter/features/dashboard/ui/dashboard_screen.dart';
import 'package:vathiyar_ai_flutter/features/my-courses/ui/my_courses_screen.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: BindingsBuilder(() {
        Get.put(GetxUserController(), permanent: true);
        Get.put(my.DrawerController(), permanent: true);
      }),

      routes: {
        "/": (context) => const LoginPage(),
        "/dashboard": (context) => Dashboard(),
        "/mycourses":(context) => MyCoures(),
      },

      initialRoute: "/",
    );
  }
}
