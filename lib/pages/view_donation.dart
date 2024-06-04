// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:caritas/pages/edit_donation.dart';
import 'package:caritas/pages/feedback_page.dart';
import 'package:caritas/pages/listing_creation_page.dart';
import 'package:caritas/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
// Dimensions in physical pixels (px)
Size size = view.physicalSize / view.devicePixelRatio;
double w = size.width;
double h = size.height;

class DonationsFragment extends StatelessWidget {
  const DonationsFragment({super.key});

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
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 270,
                                width: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/fruits.jpeg'),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 270,
                                width: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/sweets_snacks.jpeg'),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Center(
                                  child: Text(
                                    "2+ \nImage",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // Expanded(
                            //   child: Container(
                            //     height: 270,
                            //     width: 180,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: const VideoPlayerWidget(),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Fruits and Snacks",
                          style: TextStyle(
                              fontSize: 16, color: Colors.purple[200]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nutrients for Poor Child",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "20 days left",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff9ca5bb),
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            //   Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       for (int i = 0; i < random_images.length; i++)
                            //         Container(
                            //             margin: const EdgeInsets.symmetric(
                            //                 horizontal: 0),
                            //             child: Align(
                            //               heightFactor: 0.75,
                            //               child: CircleAvatar(
                            //                 radius: 10,
                            //                 backgroundImage: NetworkImage(
                            //                   random_images[i],
                            //                 ),
                            //               ),
                            //             )),
                            //       Container(
                            //           margin: const EdgeInsets.symmetric(
                            //               horizontal: 0),
                            //           child: const Align(
                            //             heightFactor: 0.5,
                            //             child: CircleAvatar(
                            //                 radius: 10,
                            //                 backgroundColor: Color(0xff209fa6),
                            //                 child: Text(
                            //                   "25",
                            //                   style: TextStyle(
                            //                       fontSize: 8,
                            //                       color: Colors.white),
                            //                 )),
                            //           )),
                            //     ],
                            //   ),
                            //
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(children: [
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
                                            builder: (context) =>
                                                ListingCreationPage()),
                                        // ListingEditPage(listingType:'Listing', communityType :'Listing', selectedImages : 'Listing', title: 'Listing', description : 'Listing', availability: 'Listing', bestBeforeDate :'Listing', isMerchant: 'Listing')),
                                      );
                                      // Handle button press event
                                    },
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
                                    color: Color(0xff9ca5bb),
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
                                        color: Colors.purple[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        Get.to(GiveFeedbackPage());
                                        print("clicked");
                                        // Handle button press event
                                      },
                                      child: Icon(
                                        Icons.message_rounded,
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage()),
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
                              " by ",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              "Laury",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.purple[200],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            //     child: Align(
            //       alignment: Alignment.bottomCenter,
            //       child: SizedBox(
            //         width: double.infinity,
            //         height: 70,
            //         child: ElevatedButton(
            //           onPressed: () {
            //             showModalBottomSheet<void>(
            //               context: context,
            //               builder: (BuildContext context) {
            //                 return Container(
            //                   decoration: BoxDecoration(
            //                       color: const Color(0xff209fa6),
            //                       borderRadius: BorderRadius.circular(10)),
            //                   height: 500,
            //                   child: Center(
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: <Widget>[
            //                         const Text('Modal BottomSheet'),
            //                         ElevatedButton(
            //                           child: const Text('Close BottomSheet'),
            //                           onPressed: () => Navigator.pop(context),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               },
            //             );
            //           },
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: const Color(0xFF209FA6),
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(20)),
            //             ),
            //           ),
            //           child: const Text(
            //             "Donate",
            //             style: TextStyle(
            //               fontSize: 20,
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            //
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const VideoPlayerScreen();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(children: [
                VideoPlayer(_controller),
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          // If the video is playing, pause it.
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            // If the video is paused, play it.
                            _controller.play();
                          }
                        });
                      },
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: const Color(
                            0xff209fa6), // Adjust icon color to match theme
                      ),
                    ),
                  ),
                )
              ]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class ArticleDetailsPage extends StatelessWidget {
//   final String image;
//   final String articleName;
//   final String articleDescription;

//   ArticleDetailsPage({
//     required this.image,
//     required this.articleName,
//     required this.articleDescription,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Article Details'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               // Handle edit button press
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               // Handle delete button press
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {
//               // Handle share button press
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.message),
//             onPressed: () {
//               // Handle message button press
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset(
//             image,
//             height: MediaQuery.of(context).size.height / 2,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   articleName,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(articleDescription),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Example usage:
// final sampleArticle = ArticleDetailsPage(
//   image: 'assets/pp.jpeg', // Replace with donor's profile image URL
//   articleName: 'Sample Article',
//   articleDescription:
//       'This is a placeholder description for the sample article.',
// );
