// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:caritas/pages/Donation/view_donation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});

  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text('My Schedule',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25)))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Calendar widget
              TableCalendar(
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: DateTime.now(),
                // Customize other properties as needed
              ),
              SizedBox(height: 16), // Add spacing
              // List of scheduled programs (cards)
              Container(
                // afficher les 3 derniers dons
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestoreInstance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("donations")
                        .orderBy('donationDate', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                return _scheduleDonationCard(donation, context);
                              },
                            );
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _scheduleDonationCard(DocumentSnapshot donation, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fastfood_outlined),
            title: Text(
              'Thanks for Sharing!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
