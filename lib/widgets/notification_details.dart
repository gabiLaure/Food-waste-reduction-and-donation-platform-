// notification_details_page.dart
// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:caritas/pages/chat_bubble.dart';
import 'package:caritas/pages/notification_details_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

enum MessageType {
  Sender,
  Reciever,
}

// class NotificationDetailsPage extends StatefulWidget {
//   //final int notificationId;

//   @override
//   State<NotificationDetailsPage> createState() =>
//       _NotificationDetailsPageState();
// }

// class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
//   List<ChatMessage> chatMessage = [
//     ChatMessage(message: "Hey Christou", type: MessageType.Sender),
//     ChatMessage(message: "Hi Laury", type: MessageType.Reciever),
//     ChatMessage(message: "How are you doing?", type: MessageType.Sender),
//     ChatMessage(
//         message: "I'm good, what about you?", type: MessageType.Reciever),
//     ChatMessage(message: "Lil Sick, On drip", type: MessageType.Sender),
//   ];

//   List<SendMenuItems> menuItems = [
//     SendMenuItems(
//         text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
//     SendMenuItems(
//         text: "Documents", icons: Icons.insert_drive_file, color: Colors.blue),
//     SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.brown),
//     SendMenuItems(
//         text: "Location", icons: Icons.location_on, color: Colors.cyan),
//     SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.green)
//   ];

//   void showModal() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 2,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(20),
//                     topLeft: Radius.circular(20))),
//             child: Column(
//               children: [
//                 Center(
//                     child: Container(
//                   height: 4,
//                   width: 5,
//                   color: Colors.grey.shade200,
//                 )),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ListView.builder(
//                     itemCount: menuItems.length,
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Container(
//                         padding: EdgeInsets.only(top: 10, bottom: 10),
//                         child: ListTile(
//                           leading: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: menuItems[index].color.shade100,
//                             ),
//                             height: 50,
//                             width: 50,
//                             child: Icon(
//                               menuItems[index].icons,
//                               size: 30,
//                               color: menuItems[index].color.shade400,
//                             ),
//                           ),
//                           title: Text(menuItems[index].text),
//                         ),
//                       );
//                     })
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Replace with your logic to fetch notification details based on notificationId
//     final String notificationTitle = 'Notification Title';
//     final String notificationBody = 'Notification Body';

//     return Scaffold(
//         appBar: NotificationDetailsAppbar(),
//         body: Stack(
//           children: [
//             ListView.builder(
//               itemBuilder: (context, index) {
//                 return ChatBubble(
//                   chatMessage: chatMessage[index],
//                 );
//               },
//               itemCount: chatMessage.length,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                   padding: EdgeInsets.only(left: 12, right: 12),
//                   height: 80,
//                   width: double.infinity,
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           showModal();
//                         },
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 146, 142, 146),
//                               borderRadius: BorderRadius.circular(30)),
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 26,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 16,
//                       ),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             focusColor: Colors.grey[100],
//                             hintText: 'Enter message',
//                             contentPadding: const EdgeInsets.symmetric(
//                               vertical: 20.0,
//                               horizontal: 20.0,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 padding: EdgeInsets.only(right: 30, bottom: 50),
//                 child: FloatingActionButton(
//                   onPressed: () {},
//                   child: Icon(
//                     Icons.send,
//                     color: Colors.white,
//                   ),
//                   backgroundColor: Colors.purple[200],
//                   elevation: 0,
//                 ),
//               ),
//             )
//           ],
//         ));
//   }
// }

// class SendMenuItems {
//   String text;
//   IconData icons;
//   MaterialColor color;
//   SendMenuItems({required this.text, required this.icons, required this.color});
// }

class NotificationDetailsPage extends StatefulWidget {
  NotificationDetailsPage({super.key});

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  final List<types.Message> _messages = [];

  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // capturer une photo et envoyer
  void _handlePhotoCapture() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final bytes = await pickedFile!.readAsBytes();
    // width of image
    // final width = pickedFile.width;
/* 
author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
*/
    final message = types.ImageMessage(
      author: _user,
      id: const Uuid().v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      uri: pickedFile.path,
      name: pickedFile.name,
      size: bytes.length,
      // height: pickedFile.height.toDouble(),
    );
    _addMessage(message);
  }

  // Utilisez ici la fonction d'envoi de message de votre application

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // take a capture
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handlePhotoCapture();
                },
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera),
                          Text('Photo'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  //child: Text('Image'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image),
                          Text('Galerie'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  //child: Text('Fichier'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.insert_drive_file),
                          Text('Fichier'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  // child: Text('Annuler'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel),
                          Text('Annuler'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          // final connectivityResult = await (Connectivity().checkConnectivity());

          // if (connectivityResult == ConnectivityResult.none) {
          //   // Pas de connexion internet
          //   throw SocketException('Pas de connexion internet');
          // }

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));

          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } on SocketException catch (_) {
          // Gérez l'exception de socket ici
          print('Pas de connexion. Échec du chargement des données');
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationDetailsAppbar(),
      body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _user,
          theme: const DefaultChatTheme(
            seenIcon: Icon(
              Icons.done_all,
              size: 16.0,
              color: Colors.deepPurple,
            ),
            inputBackgroundColor: Colors.deepPurple,
          )),
    );
  }
}
