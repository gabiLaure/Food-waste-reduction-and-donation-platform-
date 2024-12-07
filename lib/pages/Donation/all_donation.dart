// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/models/donation.dart';
import 'package:caritas/models/user_model.dart';
import 'package:caritas/widgets/feedback_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caritas/widgets/toast_messages.dart';

import 'view_donation.dart';

final String userProfileID = FirebaseAuth.instance.currentUser!.uid.toString();

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

  void acceptDonation(DocumentSnapshot<Object?> donation) async {
    try {
      // Met à jour le statut de la donation dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'donations') // Remplacez par le nom correct de la collection
          .doc(donation['donationID']) // L'ID du document de la donation
          .update({
        'donationStatus': 'Accepted', // Nouveau statut
        'orphanAccept': GlobalData.orphanageData,
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });
      ToastMessages().showSuccessToast('Donation accepted successfully..');
    } catch (e) {
      ToastMessages().showErrorToast("Error while accepting donation: $e");
    }
  }

  void declineDonation(DocumentSnapshot<Object?> donation) async {
    try {
      // Met à jour le statut de la donation dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'donations') // Remplacez par le nom correct de la collection
          .doc(donation['donationID']) // L'ID du document de la donation
          .update({
        'donationStatus': 'Declined', // Nouveau statut
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });

      ToastMessages().showSuccessToast('Donation declined successfully.');
    } catch (e) {
      ToastMessages().showErrorToast("Error while declined donation: $e");
    }
  }

  void cancelDonation(DocumentSnapshot<Object?> donation) async {
    try {
      // Met à jour le statut de la donation dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'donations') // Remplacez par le nom correct de la collection
          .doc(donation['donationID']) // L'ID du document de la donation
          .update({
        'donationStatus': 'Cancel', // Nouveau statut
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });

      ToastMessages().showSuccessToast('Donation declined successfully.');
    } catch (e) {
      ToastMessages().showErrorToast("Error while declined donation: $e");
    }
  }

  // Widget pour afficher
  Widget donationListStreamOrphanage(
      {required String status, required String emptyMessage}) {
    final orphanageId = GlobalData.orphanageData!['id'];
    final userId = GlobalData.userData!['userUid'];
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("donations")
          .where(
            Filter.or(
              Filter('orphanage.id', isEqualTo: orphanageId),
              Filter('userInfos.userUid', isEqualTo: userId),
            ),
          )
          .where('donationStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return !snapshot.hasData
            ? Container()
            : snapshot.data!.docs.isEmpty
                ? Center(child: Text(emptyMessage))
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot donation = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DonationCard(
                          title: donation['donationTitle'],
                          quantity: '${donation['quantity']!.toString()} kg',
                          distance:
                              '${donation['distanceBetweenUs']!.toStringAsFixed(2)} km',
                          collectionTime: donation['donationAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        declineDonation(donation);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Decline'),
                                  ),
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      acceptDonation(donation);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Accept'),
                                  ),
                                if (status == 'Accepted')
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => GiveFeedbackPage(),
                                          arguments: {
                                            'donationID':
                                                donation['donationID'],
                                            'donationTitle':
                                                donation['donationTitle']
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
      },
    );
  }

  Widget donationListStreamRestaurant(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("donations")
          .where('userInfos.userUid',
              isEqualTo: GlobalData.userData!['userUid'])
          .where('donationStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return !snapshot.hasData
            ? Container()
            : snapshot.data!.docs.isEmpty
                ? Center(child: Text(emptyMessage))
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot donation = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DonationCard(
                          title: donation['donationTitle'],
                          quantity: '${donation['quantity']!.toString()} kg',
                          distance: '-',
                          collectionTime: donation['donationAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildViewDonationButton(context, donation),
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        cancelDonation(donation);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Cancel'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
      },
    );
  }

  Widget _buildViewDonationButton(BuildContext context, donation) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonationsFragment(donation)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 223, 230, 200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('View Donation'),
    );
  }

  Widget donationListStreamSupermarket(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("donations")
          .where('userInfos.userUid',
              isEqualTo: GlobalData.userData!['userUid'])
          .where('donationStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return !snapshot.hasData
            ? Container()
            : snapshot.data!.docs.isEmpty
                ? Center(child: Text(emptyMessage))
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot donation = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DonationCard(
                          title: donation['donationTitle'],
                          quantity: '${donation['quantity']!.toString()} kg',
                          distance: '-',
                          collectionTime: donation['donationAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        cancelDonation(donation);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Cancel'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
      },
    );
  }

  List<Tab> displayTabs() {
    String accountType = GlobalData.userData?['accountType'] ?? '';

    switch (accountType) {
      case 'Orphanage':
        return [
          Tab(text: 'Pending Offers'),
          Tab(text: 'To be collected'),
          Tab(text: 'Denied Offers'),
        ];
      case 'Restaurant':
      case 'Individual':
      case 'Supermarket':
        return [
          Tab(text: 'Pending Offers'),
          Tab(text: 'Collected Offers'),
          Tab(text: 'Cancel Offers'),
        ];
      default:
        return [
          Tab(text: 'Pending Offers'),
          Tab(text: 'To be collected'),
          Tab(text: 'Cancel Offers'),
        ];
    }
  }

  List<Widget> displayTabsContent() {
    String accountType = GlobalData.userData?['accountType'] ?? '';

    switch (accountType) {
      case 'Orphanage':
        return [
          // Onglet des offres en attente
          donationListStreamOrphanage(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          donationListStreamOrphanage(
            status: 'Accepted',
            emptyMessage: 'No donations to be collected...',
          ),
          // Onglet des offres refusées
          donationListStreamOrphanage(
            status: 'Declined',
            emptyMessage: 'No denied offers...',
          ),
        ];
      case 'Restaurant':
      case 'Individual':
      case 'Supermarket':
        return [
          // Onglet des offres en attente
          donationListStreamRestaurant(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          donationListStreamRestaurant(
            status: 'Accepted',
            emptyMessage: 'No donations to be collected...',
          ),
          // Onglet des dons à collecter
          donationListStreamRestaurant(
            status: 'Cancel',
            emptyMessage: 'No donations to be collected...',
          ),
        ];
      default:
        return [
          // Onglet des offres en attente
          donationListStreamOrphanage(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          donationListStreamOrphanage(
            status: 'Accepted',
            emptyMessage: 'No donations to be collected...',
          ),
          // Onglet des offres refusées
          donationListStreamOrphanage(
            status: 'Declined',
            emptyMessage: 'No denied offers...',
          ),
        ];
    }
  }

  Widget donationListStreamIndividual(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("donations")
          .where('userUid',
              isEqualTo: FirebaseAuth.instance.currentUser
                  ?.uid) // Filter by the current user's UID
          .where('donationStatus',
              isEqualTo: status) // Filter by donation status
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return !snapshot.hasData
            ? Container()
            : snapshot.data!.docs.isEmpty
                ? Center(child: Text(emptyMessage))
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot donation = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DonationCard(
                          title: donation['donationTitle'],
                          quantity: '${donation['quantity']!.toString()} kg',
                          distance:
                              '${donation['distanceBetweenUs']!.toStringAsFixed(2)} km',
                          collectionTime: donation['donationAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        declineDonation(donation);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Decline'),
                                  ),
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      acceptDonation(donation);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Accept'),
                                  ),
                                if (status == 'Accepted')
                                  ElevatedButton(
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('View Donation'),
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => GiveFeedbackPage(),
                                        arguments: {
                                          'donationID': donation['donationID'],
                                          'donationTitle':
                                              donation['donationTitle']
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabHeader = displayTabs();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations'),
      ),
      body: DefaultTabController(
        length: tabHeader.length,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: tabHeader,
            ),
            Expanded(
              child: TabBarView(children: displayTabsContent()),
            ),
          ],
        ),
      ),
    );
  }
}
