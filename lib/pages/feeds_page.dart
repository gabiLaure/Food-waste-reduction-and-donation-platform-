import 'package:caritas/pages/listing_creation_page.dart';
import 'package:caritas/pages/view_donation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:caritas/pages/view_donation.dart';

import '../widgets/food_category.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.asset("assets/videos/orphan_image.mp4");

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
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Column(children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            FoodCategoriesPage(),
            SizedBox(
              height: 14,
            ),
            Text(
              'Donation Transfers',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Hi Caritas Chief! Are you able to donate today?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.watch_later_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Post your product and availability...'),
                        ],
                      ),
                      // Add more lines as needed
                      leading: Icon(Icons.lunch_dining),
                    ),
                    SizedBox(height: 16), // Add spacing between rows
                    // Second row with elevated buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle button 2 press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust corner radius
                              ),
                            ),
                            child: Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle button 2 press
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListingCreationPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust corner radius
                              ),
                            ),
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'My Sheduled Donation',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.fastfood_outlined),
                      title: Text(
                        'Thanks for Sharing!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              SizedBox(
                                width: 5,
                              ),
                              Text('7 kg'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 3,
                              ),
                              Text('100km'),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(Icons.watch_later_outlined),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Collection (evening)'),
                            ],
                          ),

                          // Add more lines as needed
                        ],
                      ),
                    ),
                    // Second row with elevated buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button 2 press
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DonationsFragment()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust corner radius
                          ),
                        ),
                        child: Text('View Donation'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ]))
      ]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
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
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
