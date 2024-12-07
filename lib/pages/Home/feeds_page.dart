// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:caritas/pages/Donation/listing_creation_page.dart';
import 'package:caritas/pages/Donation/view_donation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/top_user.dart';
import '../Food Tips/food_category.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DateTime selectedDate = DateTime.now();
  final firestoreInstance = FirebaseFirestore.instance;

  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                TopUsersCarousel(),
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
                Container(
                  // afficher les 5 derniers dons
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestoreInstance
                          .collection("donations")
                          .where('userInfos.userUid',
                              isEqualTo:
                                  userProfileID) // Filtrer par UID de l'utilisateur actuel
                          .where('donationStatus', isEqualTo: "Pending")
                          .limit(5) // Limiter à 5 résultats
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return !snapshot.hasData
                            ? Container()
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot donation =
                                      snapshot.data!.docs[index];
                                  return _scheduleDonationCard(
                                      context, donation);
                                },
                              );
                      })),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _scheduleDonationCard(BuildContext context, DocumentSnapshot donation) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fastfood_outlined),
            title: Text(
              "Thanks for Sharing ${donation['donationTitle']}!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined),
                    SizedBox(width: 5),
                    Text(
                      '${donation['quantity']!.toString()} kg',
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.location_on),
                    SizedBox(width: 3),
                    Text(
                        '${donation['distanceBetweenUs']!.toStringAsFixed(2)} km'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined),
                    SizedBox(width: 5),
                    Text(donation['donationAvailability']),
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
                      builder: (context) => DonationsFragment(
                          donation)), // Correct the navigation destination
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
  );
}
