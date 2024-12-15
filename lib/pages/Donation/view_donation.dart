// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/pages/Donation/all_donation.dart';
import 'package:caritas/pages/Donation/edit_donation.dart';
import 'package:caritas/pages/Home/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../widgets/toast_messages.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
// Dimensions in physical pixels (px)
Size size = view.physicalSize / view.devicePixelRatio;
double w = size.width;
double h = size.height;

class DonationsFragment extends StatefulWidget {
  final donation;
  const DonationsFragment(this.donation, {super.key});

  @override
  State<DonationsFragment> createState() => _DonationsFragmentState();
}

class _DonationsFragmentState extends State<DonationsFragment> {
  LatLng? _currentPosition;
  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Donations",
            style: TextStyle(
              color: Colors.black, // Adjust color to match theme
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: const BackButton(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            )
          ],
          backgroundColor:
              Colors.white, // Adjust background color to match other screens
        ),
        body: SafeArea(child: _donationDetail(widget.donation, context)));
  }

  Widget _donationDetail(donation, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 270, // Hauteur fixe pour le conteneur
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: donation['donationImages'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0), // Espacement entre les images
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: donation['donationImages'][index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  donation['donationTitle'],
                  //"Fruits and Snacks",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[200]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        getTimeElapsed(donation['donationDate']),
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff9ca5bb),
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 135, 170, 230),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: GestureDetector(
                            onTap: () {
                              // Assuming you have a variable 'donation' which holds the current donation data
                              var donation = {
                                'foodType': 'Vegetable',
                                'description': 'Fresh organic vegetables',
                                'quantity': 20,
                                'community': 'Local Community',
                                'location': 'Downtown',
                                'foodImage':
                                    'https://example.com/food_image.jpg', // Sample URL for food image
                              };

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDonationPage(
                                    donationData: donation,
                                  ),
                                ),
                              );
                            },
                            // Handle button press event
                            child: Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white,
                            ),
                          )),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 164, 167, 170),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ]),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: GestureDetector(
                              onTap: () {
                                //Get.to(GiveFeedbackPage());
                                print(
                                  getTimeElapsed(donation['donationDate']),
                                );
                                // Handle button press event
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9ca5bb),
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.purple[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationPage()),
                                );
                              },
                              child: Icon(
                                Icons.message_rounded,
                                color: Colors.white,
                              ),
                            )),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Message",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9ca5bb),
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ]),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/pp.jpeg'),
                    ),
                    Text(
                      " By ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      donation['userInfos']['fullname'],
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.purple[200],
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "This donation includes ${donation['quantity'] ?? 'N/A'} items located at ${donation['distanceBetweenUs'] ?? 'unknown distance'}. "
                  "It is ${donation['donationAvailability'] ?? 'not specified'} for pickup. Details: ${donation['donationDescription'] ?? 'no description provided'}. Consume before: ${donation['donationBestBefore']}",
                  style: TextStyle(fontSize: 20),
                  softWrap: true,
                ),
                Text(
                  "Accepted by : ${donation['orphanage']['orphanageName'] ?? 'No one yet'}. ",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple[200],
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                _buildAcceptButton(context, donation)
              ],
            ),
          ),
        )
      ],
    );
  }

  void acceptDonation(context, donation) async {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllDonations(), // Replace with your actual notification page
        ),
      );
    } catch (e) {
      ToastMessages().showErrorToast("Error while accepting donation: $e");
    }
  }

  _buildAcceptButton(context, donation) {
    final distanceInMeters = Geolocator.distanceBetween(
      _currentPosition != null ? _currentPosition!.latitude : 0.0,
      _currentPosition != null ? _currentPosition!.longitude : 0.0,
      donation['latitude'],
      donation['longitude'],
    );
    // Store calculated distance
    final distanceBetweenUs = distanceInMeters / 1000;

    return distanceBetweenUs <= 20
        ? ElevatedButton(
            onPressed: () {
              acceptDonation(context, donation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Accept'),
          )
        : SizedBox();
  }

  String getTimeElapsed(dynamic donationDate) {
    DateTime parsedDate;

    // Handle Firestore Timestamp
    if (donationDate is Timestamp) {
      parsedDate = donationDate.toDate();
    }
    // Handle formatted String date
    else if (donationDate is String) {
      try {
        DateFormat dateFormat = DateFormat("dd-MM-yyyy, HH:mm:a");
        parsedDate = dateFormat.parse(donationDate);
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Invalid date';
    }

    final now = DateTime.now();
    final difference = now.difference(parsedDate);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years > 1 ? 'years' : 'year'} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months > 1 ? 'months' : 'month'} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours > 1 ? 'hours' : 'hour'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    } else {
      return 'Just now';
    }
  }
}
