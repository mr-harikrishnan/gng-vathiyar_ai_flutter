import 'package:flutter/material.dart';
import 'package:vathiyar_ai_flutter/app-colors.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito-service.dart';
import 'package:vathiyar_ai_flutter/core/storage/secure-storage/secure-storage.dart';
import 'package:vathiyar_ai_flutter/widgets/show-yes-no-dailog.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // State variable

  String userName = "Loading...";

  // Runs once when widget loads

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Call async method here
  }

  // Read secure storage

  Future<void> _loadUserName() async {
    final storedUserName = await readSecureData("username");

    // Update UI after async call
    setState(() {
      userName = storedUserName ?? "Unknown User";
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          _drawerHeader(userName),

          const Divider(),

          _drawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
            currentRoute: currentRoute,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),

          _drawerItem(
            context,
            icon: Icons.school,
            title: 'My Courses',
            route: '/mycourses',
            currentRoute: currentRoute,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/mycourses');
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
                await CognitoService.signOut();
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }

  // Drawer Header

  Widget _drawerHeader(String userName) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Logged in as",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required String? currentRoute,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.greydark),
      title: Text(title, style: const TextStyle(color: AppColors.greydark)),
      onTap: onTap,
    );
  }
}
