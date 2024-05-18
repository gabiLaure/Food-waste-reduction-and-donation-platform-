// notification_details_page.dart
import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatelessWidget {
  final int notificationId;

  NotificationDetailsPage({required this.notificationId});

  @override
  Widget build(BuildContext context) {
    // Replace with your logic to fetch notification details based on notificationId
    final String notificationTitle = 'Notification Title';
    final String notificationBody = 'Notification Body';

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $notificationTitle'),
            SizedBox(height: 8),
            Text('Body: $notificationBody'),
          ],
        ),
      ),
    );
  }
}
