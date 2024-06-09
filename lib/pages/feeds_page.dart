// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:caritas/pages/listing_creation_page.dart';
import 'package:caritas/pages/view_donation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/food_category.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> mediaItems = [
    {'type': 'image', 'path': 'assets/images/orphanage1.jpeg'},
    {'type': 'image', 'path': 'assets/images/orphanage2.jpeg'},
    {'type': 'video', 'path': 'assets/videos/orphanage1.mp4'},
    {'type': 'video', 'path': 'assets/videos/orphanage2.mp4'},
    {'type': 'video', 'path': 'assets/videos/orphanage3.mp4'},
  ];

  List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (var item in mediaItems) {
      if (item['type'] == 'video') {
        VideoPlayerController controller =
            VideoPlayerController.asset(item['path']!)
              ..initialize().then((_) {
                setState(() {});
              });
        _videoControllers.add(controller);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: mediaItems.map((item) {
        if (item['type'] == 'image') {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(item['path']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else if (item['type'] == 'video') {
          int index = mediaItems.indexOf(item) - 2;

          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: _videoControllers[index].value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoControllers[index].value.aspectRatio,
                        child: VideoPlayer(_videoControllers[index]),
                      )
                    : Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildCarousel(),
                SizedBox(height: 8),
                FoodCategoriesPage(),
                SizedBox(height: 14),
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
                              SizedBox(width: 5),
                              Text('Post your product and availability...'),
                            ],
                          ),
                          leading: Icon(Icons.lunch_dining),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Handle button 1 press
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
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
                                    borderRadius: BorderRadius.circular(8.0),
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
                const SizedBox(height: 10),
                const Text(
                  'My Scheduled Donation',
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
                                  SizedBox(width: 5),
                                  Text('7 kg'),
                                  SizedBox(width: 5),
                                  Icon(Icons.location_on),
                                  SizedBox(width: 3),
                                  Text('100km'),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined),
                                  SizedBox(width: 5),
                                  Text('Collection (evening)'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DonationsFragment()), // Correct the navigation destination
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('View Donation'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
