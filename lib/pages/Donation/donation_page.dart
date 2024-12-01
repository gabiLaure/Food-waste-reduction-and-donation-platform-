import 'package:caritas/admin/models/global_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:caritas/models/donation.dart';
import 'package:caritas/models/user_model.dart';
import 'package:caritas/widgets/feedback_page.dart';
import 'package:caritas/pages/Donation/listing_creation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:caritas/widgets/toast_messages.dart';

import '../Request/requesting_page.dart';
import 'all_donation.dart';

class DonationPage extends StatelessWidget {
  DonationPage({super.key});

  final firestoreInstance = FirebaseFirestore.instance;
  late Donation donation;
  late UserModelClass user;

  void acceptDonation(donation) async {
    try {
      // Met à jour le statut de la donation dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'donations') // Remplacez par le nom correct de la collection
          .doc(donation['donationID']) // L'ID du document de la donation
          .update({
        'donationStatus': 'Accepted', // Nouveau statut
        'distanceBetweenUs': donation['distanceBetweenUs'],
        'orphanage': GlobalData.orphanageData,
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });
      ToastMessages().showSuccessToast('Donation accepted successfully..');
    } catch (e) {
      ToastMessages().showErrorToast("Error while accepting donation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPendingDonationTab(),
                  _buildPendingRequestTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  // Builds the TabBar widget
  Widget _buildTabBar() {
    return TabBar(
      tabs: [
        Tab(text: 'Pending Donation'),
        Tab(text: 'Pending Request'),
      ],
    );
  }

  // Builds the Pending Donation tab content
  Widget _buildPendingDonationTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection('donations')
          .where('orphanage.id', isEqualTo: 'all-community')
          .where('donationStatus', isEqualTo: 'Pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Retrieve orphanage location
        final double? currentLatitude = GlobalData.orphanageData?['latitude'];
        final double? currentLongitude = GlobalData.orphanageData?['longitude'];

        if (currentLatitude == null || currentLongitude == null) {
          return _buildEmptyState('Location data is missing.');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('There are no donations in this area');
        }

        // Filter and calculate distance
        final nearbyDonations = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final donationLatitude = data['latitude'] ?? 0.0;
          final donationLongitude = data['longitude'] ?? 0.0;

          // Calculate distance
          final distanceInMeters = Geolocator.distanceBetween(
            currentLatitude,
            currentLongitude,
            donationLatitude,
            donationLongitude,
          );
          // Store calculated distance
          data['distanceBetweenUs'] = distanceInMeters / 1000; // Convert to km
          return data;
        }).where((data) {
          // Filter by 20km radius

          return data['distanceBetweenUs'] <= 20.0;
        }).toList();

        if (nearbyDonations.isEmpty) {
          return _buildEmptyState('No donations within 20km.');
        }
        // Build the list
        // Build the list with nearby donations
        return ListView.builder(
          itemCount: nearbyDonations.length,
          itemBuilder: (context, index) {
            final donation = nearbyDonations[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DonationCard(
                title: donation['donationTitle'],
                quantity: '${donation['quantity']} kg',
                distance:
                    '${donation['distanceBetweenUs'].toStringAsFixed(2)} km',
                collectionTime: donation['donationAvailability'],
                widget: _buildActionButtons(donation),
              ),
            );
          },
        );
      },
    );
  }

  // Builds a list of donations
  Widget _buildDonationList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot donation = snapshot.docs[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DonationCard(
            title: donation['donationTitle'],
            quantity: '${donation['quantity']} kg',
            distance: '${donation['distanceBetweenUs'].toStringAsFixed(2)} km',
            collectionTime: donation['donationAvailability'],
            widget: _buildActionButtons(donation),
          ),
        );
      },
    );
  }

  // Builds the Pending Request tab content
  Widget _buildPendingRequestTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection('request')
          .where('donationStatus', isEqualTo: 'Pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Retrieve orphanage location
        final double? currentLatitude = GlobalData.orphanageData?['latitude'];
        final double? currentLongitude = GlobalData.orphanageData?['longitude'];

        if (currentLatitude == null || currentLongitude == null) {
          return _buildEmptyState('Location data is missing.');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('There are no requests in this area');
        }

        // Filter and calculate distance
        final nearbyRequests = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final requestLatitude = data['latitude'] ?? 0.0;
          final requestLongitude = data['longitude'] ?? 0.0;

          // Calculate distance
          final distanceInMeters = Geolocator.distanceBetween(
            currentLatitude,
            currentLongitude,
            requestLatitude,
            requestLongitude,
          );

          // Store calculated distance
          data['distanceBetweenUs'] = distanceInMeters / 1000; // Convert to km
          return data;
        }).where((data) {
          // Filter by 20km radius
          return data['distanceBetweenUs'] <= 20.0;
        }).toList();

        if (nearbyRequests.isEmpty) {
          return _buildEmptyState('No requests within 20km.');
        }

        // Build the list
        return ListView.builder(
          itemCount: nearbyRequests.length,
          itemBuilder: (context, index) {
            final data = nearbyRequests[index];
            final distanceBetweenUs = data['distanceBetweenUs'];

            return ListTile(
              title: Text(data['requestTitle'] ?? "Unknown Request"),
              subtitle: Text("${distanceBetweenUs.toStringAsFixed(2)} km away"),
            );
          },
        );
      },
    );
  }

  // Builds buttons for the action (Accept, Decline, etc.)
  Widget _buildActionButtons(donation) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAcceptButton(donation),
        ],
      ),
    );
  }

  // Builds the Accept button
  Widget _buildAcceptButton(donation) {
    return ElevatedButton(
      onPressed: () {
        acceptDonation(donation);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('Accept'),
    );
  }

  // Builds the empty state UI when there are no donations or requests
  Widget _buildEmptyState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUI(),
        SizedBox(height: 20),
        Text(message, style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle expand search area button press
          },
          child: Text('Expand my search area'),
        ),
      ],
    );
  }

  // Builds the UI for loading state (Lottie animation)
  Widget _buildUI() {
    return Center(
      child: LottieBuilder.asset("assets/animation/delivery.json"),
    );
  }

  // Builds the Floating Action Button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showDialog(context),
      child: Icon(Icons.add),
    );
  }

  // Shows the dialog for making a choice
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Make a choice')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogButton(
                context,
                'Make a Donation',
                ListingCreationPage(),
              ),
              _buildDialogButton(
                context,
                'Make a Request',
                RequestDonation(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build dialog buttons
  Widget _buildDialogButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Center(child: Text(label)),
    );
  }
}
