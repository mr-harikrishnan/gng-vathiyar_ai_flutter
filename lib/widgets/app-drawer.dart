import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito-service.dart';
import 'package:vathiyar_ai_flutter/core/storage/get-x-controller/user-controller.dart';
import 'package:vathiyar_ai_flutter/widgets/show-yes-no-dailog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GetxUserController user = Get.find();
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: const Color(0xFFF5F7F6),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          _drawerHeader(user),

          const Divider(),

          // Menu items
          _drawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
            currentRoute: currentRoute,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),

          _drawerItem(
            context,
            icon: Icons.school,
            title: 'My Courses',
            route: '/mycourses',
            currentRoute: currentRoute,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/mycourses');
            },
          ),

          _drawerItem(
            context,
            icon: Icons.menu_book,
            title: 'All Courses',
            route: '/allcourses',
            currentRoute: currentRoute,
            onTap: () {
              // Navigator.pushReplacementNamed(context, '/allcourses');
            },
          ),

          const Divider(),

          _drawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            route: '/',
            currentRoute: currentRoute,
            onTap: () async {
              final result = await showYesNoDialog(
                context,
                title: 'Logout',
                content: 'Are you sure you want to logout?',
              );

              if (result) {
                // Sign out user
                await CognitoService.signOut();

                // Go to login page
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),

          const SizedBox(height: 20),

          // App info
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Version: 0.0.33\nEnvironment: production',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  // Professional Drawer Header
  Widget _drawerHeader(GetxUserController user) {
    return Container(
      padding: const EdgeInsets.only(
        top: 48,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),

          // Expanded gives width so text can wrap
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Logged in as",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 4),

                Obx(
                  () => Text(
                    user.email.value.isNotEmpty
                        ? user.email.value
                        : user.phone.value,
                    softWrap: true,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable drawer item
  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required String? currentRoute,
    required String route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
