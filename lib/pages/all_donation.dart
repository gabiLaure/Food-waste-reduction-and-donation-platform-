import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import '../widgets/food_category.dart';
import 'feedback_page.dart';
import 'listing_creation_page.dart';

class AllDonations extends StatelessWidget {
  const AllDonations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Column(children: [
        Text(
          'Pending Offers',
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
                    'Fresh Vegetables!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                        child: Text('Decline'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button 2 press
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListingCreationPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust corner radius
                          ),
                        ),
                        child: Text('Accept'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'To be collected',
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
                    "You've Accepted Yummy Cake!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                      Get.to(GiveFeedbackPage());
                      print("clicked");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Adjust corner radius
                      ),
                    ),
                    child: Text('Leave Feedback'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
