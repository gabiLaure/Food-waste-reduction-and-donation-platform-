import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSettingsTile('Profile', Icons.person, () {
              // Navigate to profile settings page
            }),
            _buildSettingsTile('Notification Preferences', Icons.notifications,
                () {
              // Navigate to notification preferences page
            }),
            _buildSettingsTile('Privacy Settings', Icons.lock, () {
              // Navigate to privacy settings page
            }),
            _buildSettingsTile('About App', Icons.info, () {
              // Show app information
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle logout action
                _showLogoutDialog(context);
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.red,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Handle actual logout logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
