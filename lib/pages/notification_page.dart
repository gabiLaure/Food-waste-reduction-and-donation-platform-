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

import 'package:caritas/widgets/notification_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow"),
    ChatUsers(
        secondaryText: 'Hello! how are you doing?',
        text: "laury",
        image: "assets/pp.jpeg",
        time: "tommorow")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsetsDirectional.all(8),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
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
                padding: EdgeInsets.only(top: 8),
                itemCount: chatUsers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return NotificationList(
                    text: chatUsers[index].text,
                    secondaryText: chatUsers[index].secondaryText,
                    image: chatUsers[index].image,
                    time: chatUsers[index].time,
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                  );
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
  bool isMessageRead = true;

  NotificationList({
    required this.secondaryText,
    required this.text,
    required this.image,
    required this.time,
    required this.isMessageRead,
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationDetailsPage()),
        );
      },
      child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Expanded(
                  child: Row(children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.image),
                      maxRadius: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.text),
                          SizedBox(
                            width: 16,
                          ),
                          Text(widget.secondaryText,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.purple[200])),
                          Text(widget.text),
                        ],
                      ),
                    ),
                    Text(widget.time,
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.isMessageRead
                                ? Colors.grey[500]
                                : Colors.amber))
                  ]),
                )
              ]))),
    );
  }
}

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;

  ChatUsers(
      {required this.secondaryText,
      required this.text,
      required this.image,
      required this.time});
}
