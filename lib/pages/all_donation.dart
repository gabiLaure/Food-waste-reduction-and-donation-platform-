// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:caritas/intro/screens/imageslider.dart';
import 'package:caritas/models/donation.dart';
import 'package:caritas/models/user_model.dart';
import 'package:caritas/pages/feedback_page.dart';
import 'package:caritas/pages/listing_creation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationCard extends StatelessWidget {
  final String title;
  final String quantity;
  final String distance;
  final String collectionTime;
  final Widget widget;

  const DonationCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.distance,
    required this.collectionTime,
    // widget
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fastfood_outlined),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined),
                    SizedBox(width: 5),
                    Text(quantity),
                    SizedBox(width: 5),
                    Icon(Icons.location_on),
                    SizedBox(width: 3),
                    Text(distance),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined),
                    SizedBox(width: 5),
                    Text("Collection($collectionTime)"),
                  ],
                ),
              ],
            ),
          ),
          widget,
        ],
      ),
    );
  }
}

class AllDonations extends StatelessWidget {
  AllDonations({super.key});
  final firestoreInstance = FirebaseFirestore.instance;
  late Donation donation;
  late UserModelClass user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'Pending Offers'),
                Tab(text: 'To be collected'),
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
                                ? Center(
                                    child: Text('No pending offers...'),
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
                                ? Center(
                                    child:
                                        Text('No donations to be collected...'),
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
            )
          ],
        ),
      ),
    );
  }
}
