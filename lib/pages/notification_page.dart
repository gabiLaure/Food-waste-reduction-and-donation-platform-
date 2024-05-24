// notifications_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:caritas/widgets/notification_details.dart';

// class NotificationPage extends StatelessWidget {
//   // Replace with your actual list of notifications
//   final List<String> notifications = [
//     'Notification 1',
//     'Notification 2',
//     'Notification 3'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(notifications[index]),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         NotificationDetailsPage(notificationId: index)),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsetsDirectional.all(8),
              child: Row(
                children: [
                  Text(
                    'Notification',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.purple),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade100))),
              ),
            ),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return;
                }),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  String text;
  String secondaryText;
  String image;
  String time;

  NotificationList({
    required this.secondaryText,
    required this.text,
    required this.image,
    required this.time,
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.image),
            maxRadius: 30,
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text),
              SizedBox(
                width: 16,
              ),
              Text(widget.secondaryText,
                  style: TextStyle(fontSize: 14, color: Colors.purple[200])),
              Text(widget.text)
            ],
          )
        ],
      ),
    );
  }
}
