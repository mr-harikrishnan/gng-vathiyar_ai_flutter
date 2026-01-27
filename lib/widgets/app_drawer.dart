import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0; // Store selected menu

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFEDF8F4),
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            color: const Color(0xFFEDF8F4),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Harikrishnan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'hari@gmail.com',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Menu items
          _drawerItem(
            context,
            index: 0,
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              setState(() {
                _selectedIndex = 0; // Update UI
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
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
              Navigator.pop(context);
              // Add logout logic
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
      leading: Icon(icon, color: isSelected ? Colors.teal : Colors.black),
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
