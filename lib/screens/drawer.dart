import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profilePictureUrl;
  final bool isBackupEnabled;
  final ValueChanged<bool> onBackupToggle;
  final VoidCallback onLogout;
  final VoidCallback onExit;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.isBackupEnabled,
    required this.onBackupToggle,
    required this.onLogout,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section with User Profile
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  profilePictureUrl), // Replace with user's profile picture URL
            ),
            decoration: BoxDecoration(
              color: Colors.purple.shade300, // Set background color
            ),
          ),
          // Backup Tasks Section
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.purple.shade300),
            title: const Text('Backup to Cloud'), // Backup Tasks to Cloud
            trailing: Switch(
              focusColor: Colors.purple.shade300,
              value: isBackupEnabled,
              onChanged: onBackupToggle,
            ),
          ),

          const Divider(),

          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.purple.shade300),
            title: const Text('Logout'),
            onTap: onLogout, // Add logout functionality here
          ),

          // Exit Button
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.purple.shade300),
            title: const Text('Exit'),
            onTap: onExit, // Add exit functionality here
          ),
        ],
      ),
    );
  }
}
