import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/services/cognito_service.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/drawer_controller.dart'
    as my;
import 'package:vathiyar_ai_flutter/core/storage/getXController/userController.dart';
import 'package:vathiyar_ai_flutter/widgets/showYesNoDailog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GetxUserController user = Get.find();
    final my.DrawerController drawerController = Get.find();

    return Drawer(
      backgroundColor: const Color(0xFFF5F7F6),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          _drawerHeader(user),

          const Divider(),

          // Menu items
          Obx(
            () => _drawerItem(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              isSelected: drawerController.selectedIndex.value == 0,
              onTap: () {
                drawerController.updateSelectedIndex(0);
                Navigator.pop(context);
              },
            ),
          ),

          Obx(
            () => _drawerItem(
              context,
              icon: Icons.school,
              title: 'My Courses',
              isSelected: drawerController.selectedIndex.value == 1,
              onTap: () {
                drawerController.updateSelectedIndex(1);
                Navigator.pop(context);
              },
            ),
          ),

          Obx(
            () => _drawerItem(
              context,
              icon: Icons.menu_book,
              title: 'All Courses',
              isSelected: drawerController.selectedIndex.value == 2,
              onTap: () {
                drawerController.updateSelectedIndex(2);
                Navigator.pop(context);
              },
            ),
          ),

          const Divider(),

          Obx(
            () => _drawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              isSelected: drawerController.selectedIndex.value == 3,
              onTap: () async {
                final result = await showYesNoDialog(
                  context,
                  title: 'Logout',
                  content: 'Are you sure you want to logout?',
                );

                if (result) {
                  drawerController.updateSelectedIndex(3);

                  // Sign out user
                  await CognitoService.signOut();

                  // Go to login page
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
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
    required bool isSelected,
  }) {
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
