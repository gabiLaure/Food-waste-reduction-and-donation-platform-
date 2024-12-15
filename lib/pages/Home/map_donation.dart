import 'package:caritas/map/custom_map.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importez votre composant CustomMap ici

class DonationMapScreen extends StatelessWidget {
  final String orphanageId = 'all-community'; // Filtre par Orphanage ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donations Map'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('orphanage.id', isEqualTo: orphanageId)
            .where('donationStatus', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Parse donations from Firestore
          List<Map<String, dynamic>> donations = snapshot.data!.docs.map((doc) {
            return {
              'donationID': doc['donationID'],
              'donationTitle': doc['donationTitle'],
              'donationDescription': doc['donationDescription'],
              'latitude': doc['latitude'],
              'longitude': doc['longitude'],
              'userInfos': doc['userInfos'],
              'orphanage': doc['orphanage'],
              'quantity': doc['quantity'],
              'donationDate': doc['donationDate'],
              'donationImages': doc['donationImages'],
              'donationStatus': doc['donationStatus'],
              'donationBestBefore': doc['donationBestBefore'],
              'donationAvailability': doc['donationAvailability'],
              'distanceBetweenUs': doc['distanceBetweenUs']
            };
          }).toList();

          return CustomMap(donations: donations);
        },
      ),
    );
  }
}
