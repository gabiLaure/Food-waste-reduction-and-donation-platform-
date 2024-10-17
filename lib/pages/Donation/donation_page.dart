import 'package:caritas/pages/Home/request_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:caritas/intro/screens/imageslider.dart';
import 'package:caritas/models/donation.dart';
import 'package:caritas/models/user_model.dart';
import 'package:caritas/widgets/feedback_page.dart';
import 'package:caritas/pages/Donation/listing_creation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'all_donation.dart';

class DonationPage extends StatelessWidget {
  DonationPage({super.key});

  final firestoreInstance = FirebaseFirestore.instance;
  late Donation donation;
  late UserModelClass user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'Pending Donation'),
                Tab(text: 'Pending Request'),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestoreInstance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("donations")
                          .where('donationStatus', isEqualTo: 'Pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return !snapshot.hasData
                            ? Container()
                            : snapshot.data!.docs.length.toString() == '0'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Animated Logo (Replace with your logo widget)
                                      _buildUI(),
                                      //CircularProgressIndicator(), // Example of a loading animation
                                      SizedBox(height: 20),
                                      Text(
                                        'There are no ads in this area',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle button press
                                        },
                                        child: Text('Expand my search area'),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot donation =
                                          snapshot.data!.docs[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DonationCard(
                                          title:
                                              "${"You've Accepted  " + donation['donationTitle']}!",
                                          //quantity: donation['quantity'],
                                          quantity: "7 kg",
                                          //distance: donation['distance'],
                                          distance: "100km",
                                          collectionTime:
                                              donation['donationAvailability'],
                                          widget: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle button 2 press
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
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
                                                        builder: (context) =>
                                                            ListingCreationPage(),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green[100],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  child: Text('Accept'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                      }),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestoreInstance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("donations")
                          .where('donationStatus', isEqualTo: 'Accepted')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return !snapshot.hasData
                            ? Container()
                            : snapshot.data!.docs.length.toString() == '0'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Animated Logo (Replace with your logo widget)
                                      _buildUI(),
                                      //CircularProgressIndicator(), // Example of a loading animation
                                      SizedBox(height: 20),
                                      Text(
                                        'There are no ads in this area',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle button press
                                        },
                                        child: Text('Expand my search area'),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot donation =
                                          snapshot.data!.docs[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DonationCard(
                                          title: donation['donationTitle'],
                                          //quantity: donation['quantity'],
                                          quantity: "7 kg",
                                          //distance: donation['distance'],
                                          distance: "100km",
                                          collectionTime:
                                              donation['donationAvailability'],
                                          widget: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        GiveFeedbackPage());
                                                    print("clicked");
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green[100],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  child: Text('Feedback'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                      }),
                ),
              ]),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return Center(
      child: LottieBuilder.asset("assets/animation/delivery.json"),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Make a choice')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the listing creation page for donation
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListingCreationPage()),
                  );
                },
                child: Center(child: Text('Make a Donation')),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the listing creation page for request
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestDonation()),
                  );
                },
                child: Center(child: Text('Make a Request')),
              ),
            ],
          ),
        );
      },
    );
  }
}
