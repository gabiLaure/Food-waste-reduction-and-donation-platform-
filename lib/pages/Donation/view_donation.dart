// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:caritas/pages/Donation/edit_donation.dart';
//import 'package:caritas/pages/listing_creation_page.dart';
import 'package:caritas/pages/Home/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
// Dimensions in physical pixels (px)
Size size = view.physicalSize / view.devicePixelRatio;
double w = size.width;
double h = size.height;

class DonationsFragment extends StatelessWidget {
  final DocumentSnapshot donation;
  const DonationsFragment(this.donation, {super.key});

  // i think this is the page should not contain this code as it is just  screen which is holding the data , it cannot show donation details
  // as the donation detaliss are show by the DonationDetails.dart file

  static List random_images = [
    'assets/pp.jpeg',
    // 'https://pbs.twimg.com/profile_images/1249432648684109824/J0k1DN1T_400x400.jpg',
    // 'https://i0.wp.com/thatrandomagency.com/wp-content/uploads/2021/06/headshot.png?resize=618%2C617&ssl=1',
    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaOjCZSoaBhZyODYeQMDCOTICHfz_tia5ay8I_k3k&s'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Donations",
            style: TextStyle(
              color: Colors.black, // Adjust color to match theme
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: const BackButton(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            )
          ],
          backgroundColor:
              Colors.white, // Adjust background color to match other screens
        ),
        body: SafeArea(child: _donationDetail(donation, context)));
  }
}

Widget _donationDetail(DocumentSnapshot donation, BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(8.0),
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                height: 270, // Hauteur fixe pour le conteneur
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: donation['donationImages'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0), // Espacement entre les images
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            imageUrl: donation['donationImages'][index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Text(
                donation['donationTitle'],
                //"Fruits and Snacks",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[200]),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      getTimeElapsed(donation['donationDate']),
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff9ca5bb),
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 135, 170, 230),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        // Assuming you have a variable 'donation' which holds the current donation data
                        var donation = {
                          'foodType': 'Vegetable',
                          'description': 'Fresh organic vegetables',
                          'quantity': 20,
                          'community': 'Local Community',
                          'location': 'Downtown',
                          'foodImage':
                              'https://example.com/food_image.jpg', // Sample URL for food image
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDonationPage(
                              donationData: donation,
                            ),
                          ),
                        );
                      },
                      // Handle button press event
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                      ),
                    )),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 164, 167, 170),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          //Get.to(GiveFeedbackPage());
                          print(
                            getTimeElapsed(donation['donationDate']),
                          );
                          // Handle button press event
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      )),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9ca5bb),
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.purple[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                        child: Icon(
                          Icons.message_rounded,
                          color: Colors.white,
                        ),
                      )),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Message",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9ca5bb),
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/pp.jpeg'),
                  ),
                  Text(
                    " By ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    donation['userInfos']['fullname'],
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.purple[200],
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "This donation includes ${donation['quantity'] ?? 'N/A'} items located at ${donation['distanceBetweenUs'] ?? 'unknown distance'}. "
                "It is ${donation['donationAvailability'] ?? 'not specified'} for pickup. Details: ${donation['donationDescription'] ?? 'no description provided'}. Consume before: ${donation['donationBestBefore']}",
                style: TextStyle(fontSize: 20),
                softWrap: true,
              ),
              Text(
                "Accepted by : ${donation['orphanage']['orphanageName'] ?? 'No one yet'}. ",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple[200],
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

String getTimeElapsed(dynamic donationDate) {
  DateTime parsedDate;

  // Handle Firestore Timestamp
  if (donationDate is Timestamp) {
    parsedDate = donationDate.toDate();
  }
  // Handle formatted String date
  else if (donationDate is String) {
    try {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy, HH:mm:a");
      parsedDate = dateFormat.parse(donationDate);
    } catch (e) {
      return 'Invalid date format';
    }
  } else {
    return 'Invalid date';
  }

  final now = DateTime.now();
  final difference = now.difference(parsedDate);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years > 1 ? 'years' : 'year'} ago';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months > 1 ? 'months' : 'month'} ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} ${difference.inHours > 1 ? 'hours' : 'hour'} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutes' : 'minute'} ago';
  } else {
    return 'Just now';
  }
}

// class VideoPlayerWidget extends StatelessWidget {
//   const VideoPlayerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const VideoPlayerScreen();
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();

//     // Create and store the VideoPlayerController. The VideoPlayerController
//     // offers several different constructors to play videos from assets, files,
//     // or the internet.
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//       ),
//     );

//     // Initialize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();

//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: Stack(children: [
//                 VideoPlayer(_controller),
//                 Center(
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white.withOpacity(0.8),
//                     child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           // If the video is playing, pause it.
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           } else {
//                             // If the video is paused, play it.
//                             _controller.play();
//                           }
//                         });
//                       },
//                       icon: Icon(
//                         _controller.value.isPlaying
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                         color: const Color(
//                             0xff209fa6), // Adjust icon color to match theme
//                       ),
//                     ),
//                   ),
//                 )
//               ]));
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
