import 'package:flutter/material.dart';

import '../widgets/notification_details.dart';

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({required this.chatMessage});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 10),
        child: Align(
          alignment: widget.chatMessage.type == MessageType.Reciever
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (widget.chatMessage.type == MessageType.Reciever
                  ? Colors.white
                  : Colors.purple[200]),
            ),
            padding: EdgeInsets.all(16),
            child: Text(widget.chatMessage.message),
          ),
        ));
  }
}

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({required this.message, required this.type});
}
