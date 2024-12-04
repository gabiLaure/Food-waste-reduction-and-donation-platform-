// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/models/user_model.dart';
import 'package:caritas/widgets/feedback_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caritas/widgets/toast_messages.dart';

import 'view_request_page.dart';

final String userProfileID = FirebaseAuth.instance.currentUser!.uid.toString();

class RequestCard extends StatelessWidget {
  final String title;
  final String quantity;
  final String distance;
  final String collectionTime;
  final Widget widget;

  const RequestCard({
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

class AllRequests extends StatelessWidget {
  AllRequests({super.key});
  final firestoreInstance = FirebaseFirestore.instance;
  //late Request request;
  late UserModelClass user;
  void acceptRequest(DocumentSnapshot<Object?> request) async {
    try {
      // Met à jour le statut de la request dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'requests') // Remplacez par le nom correct de la collection
          .doc(request['requestID']) // L'ID du document de la request
          .update({
        'requestStatus': 'Accepted', // Nouveau statut
        'orphanAccept': GlobalData.orphanageData,
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });
      ToastMessages().showSuccessToast('Request accepted successfully..');
    } catch (e) {
      ToastMessages().showErrorToast("Error while accepting request: $e");
    }
  }

  void declineRequest(DocumentSnapshot<Object?> request) async {
    try {
      // Met à jour le statut de la request dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'requests') // Remplacez par le nom correct de la collection
          .doc(request['requestID']) // L'ID du document de la request
          .update({
        'requestStatus': 'Declined', // Nouveau statut
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });

      ToastMessages().showSuccessToast('Request declined successfully.');
    } catch (e) {
      ToastMessages().showErrorToast("Error while declined request: $e");
    }
  }

  void cancelRequest(DocumentSnapshot<Object?> request) async {
    try {
      // Met à jour le statut de la request dans Firestore
      await FirebaseFirestore.instance
          .collection(
              'requests') // Remplacez par le nom correct de la collection
          .doc(request['requestID']) // L'ID du document de la request
          .update({
        'requestStatus': 'Cancel', // Nouveau statut
        'updatedAt':
            FieldValue.serverTimestamp(), // Met à jour la date si nécessaire
      });

      ToastMessages().showSuccessToast('request declined successfully.');
    } catch (e) {
      ToastMessages().showErrorToast("Error while declined request: $e");
    }
  }

  // Widget pour afficher
  Widget requestListStreamOrphanage(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("requests")
          .where('orphanage.id', isEqualTo: GlobalData.orphanageData!['id'])
          .where('requestStatus', isEqualTo: status)
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
                      DocumentSnapshot request = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RequestCard(
                          title: request['requestTitle'],
                          quantity: '${request['quantity']!.toString()} kg',
                          distance:
                              '${request['distanceBetweenUs']!.toStringAsFixed(2)} km',
                          collectionTime: request['requestAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        declineRequest(request);
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
                                      acceptRequest(request);
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
                                            'requestID': request['requestID'],
                                            'requestTitle':
                                                request['requestTitle']
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

  Widget requestListStreamRestaurant(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("requests")
          .where('userInfos.userUid',
              isEqualTo: GlobalData.userData!['userUid'])
          .where('requestStatus', isEqualTo: status)
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
                      DocumentSnapshot request = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RequestCard(
                          title: request['requestTitle'],
                          quantity: '${request['quantity']!.toString()} kg',
                          distance: '-',
                          collectionTime: request['requestAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        cancelRequest(request);
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

  Widget requestListStreamSupermarket(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("requests")
          .where('userInfos.userUid',
              isEqualTo: GlobalData.userData!['userUid'])
          .where('requestStatus', isEqualTo: status)
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
                      DocumentSnapshot request = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RequestCard(
                          title: request['requestTitle'],
                          quantity: '${request['quantity']!.toString()} kg',
                          distance: '-',
                          collectionTime: request['requestAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        cancelRequest(request);
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
          Tab(text: 'Denied Offers'),
        ];
    }
  }

  List<Widget> displayTabsContent() {
    String accountType = GlobalData.userData?['accountType'] ?? '';

    switch (accountType) {
      case 'Orphanage':
        return [
          // Onglet des offres en attente
          requestListStreamOrphanage(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          requestListStreamOrphanage(
            status: 'Accepted',
            emptyMessage: 'No requests to be collected...',
          ),
          // Onglet des offres refusées
          requestListStreamOrphanage(
            status: 'Declined',
            emptyMessage: 'No denied offers...',
          ),
        ];
      case 'Restaurant':
      case 'Individual':
      case 'Supermarket':
        return [
          // Onglet des offres en attente
          requestListStreamRestaurant(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          requestListStreamRestaurant(
            status: 'Accepted',
            emptyMessage: 'No requests to be collected...',
          ),
          // Onglet des dons à collecter
          requestListStreamRestaurant(
            status: 'Cancel',
            emptyMessage: 'No requests to be collected...',
          ),
        ];
      default:
        return [
          // Onglet des offres en attente
          requestListStreamOrphanage(
            status: 'Pending',
            emptyMessage: 'No pending offers...',
          ),
          // Onglet des dons à collecter
          requestListStreamOrphanage(
            status: 'Accepted',
            emptyMessage: 'No requests to be collected...',
          ),
          // Onglet des offres refusées
          requestListStreamOrphanage(
            status: 'Declined',
            emptyMessage: 'No denied offers...',
          ),
        ];
    }
  }

  Widget requestListStreamIndividual(
      {required String status, required String emptyMessage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("requests")
          .where('userUid',
              isEqualTo: FirebaseAuth.instance.currentUser
                  ?.uid) // Filter by the current user's UID
          .where('requestStatus', isEqualTo: status) // Filter by request status
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
                      DocumentSnapshot request = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RequestCard(
                          title: request['requestTitle'],
                          quantity: '${request['quantity']!.toString()} kg',
                          distance:
                              '${request['distanceBetweenUs']!.toStringAsFixed(2)} km',
                          collectionTime: request['requestAvailability'],
                          widget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (status == 'Pending')
                                  ElevatedButton(
                                    onPressed: () {
                                      if (status == 'Pending') {
                                        declineRequest(request);
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
                                      acceptRequest(request);
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
                                            builder: (context) =>
                                                RequestsFragment()), // Correct the navigation destination
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('View request'),
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => GiveFeedbackPage(),
                                        arguments: {
                                          'requestID': request['requestID'],
                                          'requestTitle':
                                              request['requestTitle']
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
        title: Text('My requests'),
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
