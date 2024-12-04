import 'package:flutter/material.dart';

class NotificationPreferencesPage extends StatefulWidget {
  @override
  _NotificationPreferencesPageState createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Email Notifications'),
              value: emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  emailNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              value: pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('SMS Notifications'),
              value: smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  smsNotifications = value;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save preferences or perform other actions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preferences saved')),
                  );
                },
                child: Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
