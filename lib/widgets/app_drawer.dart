import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito_service.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/userController.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GetxUserController user = Get.find();

    return Drawer(
      backgroundColor: const Color(0xFFEDF8F4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          _drawerHeader(user),

          const Divider(),

          // Menu items
          _drawerItem(
            context,
            index: 0,
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),

          _drawerItem(
            context,
            index: 1,
            icon: Icons.school,
            title: 'My Courses',
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
            },
          ),

          _drawerItem(
            context,
            index: 2,
            icon: Icons.menu_book,
            title: 'All Courses',
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _drawerItem(
            context,
            index: 3,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              setState(() {
                _selectedIndex = 3;
              });

              // Sign out user
              await CognitoService.signOut();

              // Go to login page
              Navigator.pushReplacementNamed(context, '/');
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
        color: Color(0xFFEDF8F4),
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
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.teal : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.teal : Colors.black,
        ),
      ),
      tileColor: isSelected ? Colors.white : null,
      onTap: onTap,
    );
  }
}
