// notifications_list_page.dart
import 'package:flutter/material.dart';
import 'package:caritas/widgets/notification_details.dart';

class NotificationsListPage extends StatelessWidget {
  // Replace with your actual list of notifications
  final List<String> notifications = ['Notification 1', 'Notification 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotificationDetailsPage(notificationId: index)),
              );
            },
          );
        },
      ),
    );
  }
}
