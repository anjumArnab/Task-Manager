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
              backgroundImage: NetworkImage(profilePictureUrl), // Replace with user's profile picture URL
            ),
          ),
          // Backup Tasks Section
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Backup to Cloud'), // Backup Tasks to Cloud
            trailing: Switch(
              value: isBackupEnabled,
              onChanged: onBackupToggle,
            ),
          ),
          
          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout, // Add logout functionality here
          ),

          // Exit Button
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            onTap: onExit, // Add exit functionality here
          ),
        ],
      ),
    );
  }
}
