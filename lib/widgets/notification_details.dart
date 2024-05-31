// notification_details_page.dart
import 'package:caritas/pages/chat_bubble.dart';
import 'package:caritas/pages/notification_details_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

enum MessageType {
  Sender,
  Reciever,
}

class NotificationDetailsPage extends StatefulWidget {
  //final int notificationId;

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  List<ChatMessage> chatMessage = [
    ChatMessage(message: "Hey Christou", type: MessageType.Sender),
    ChatMessage(message: "Hi Laury", type: MessageType.Reciever),
    ChatMessage(message: "How are you doing?", type: MessageType.Sender),
    ChatMessage(
        message: "I'm good, what about you?", type: MessageType.Reciever),
    ChatMessage(message: "Lil Sick, On drip", type: MessageType.Sender),
  ];

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Documents", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.brown),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.cyan),
    SendMenuItems(text: "Conatact", icons: Icons.person, color: Colors.green)
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 5,
                  color: Colors.grey.shade200,
                )),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade100,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 30,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    })
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Replace with your logic to fetch notification details based on notificationId
    final String notificationTitle = 'Notification Title';
    final String notificationBody = 'Notification Body';

    return Scaffold(
        appBar: NotificationDetailsAppbar(),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return ChatBubble(
                  chatMessage: chatMessage[index],
                );
              },
              itemCount: chatMessage.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  height: 80,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModal();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 146, 142, 146),
                              borderRadius: BorderRadius.circular(30)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            focusColor: Colors.grey[100],
                            hintText: 'Enter message',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30, bottom: 50),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.purple[200],
                  elevation: 0,
                ),
              ),
            )
          ],
        ));
  }
}

class SendMenuItems {
  String text;
  IconData icons;
  MaterialColor color;
  SendMenuItems({required this.text, required this.icons, required this.color});
}
