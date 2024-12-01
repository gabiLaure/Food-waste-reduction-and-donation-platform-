// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:caritas/generators/uuid_generator.dart';
import 'package:caritas/home.dart';
import 'package:caritas/pages/Geotargeting/map.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:caritas/map/screens/current_location_screen.dart';

import '../Orphanage/map_picker.dart';

class RequestDonation extends StatefulWidget {
  @override
  State<RequestDonation> createState() => _RequestDonationState();
}

class _RequestDonationState extends State<RequestDonation> {
  //String _output = '';
  //late LatLng _selectedLocation;

  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double? circularProgressVal;

  /* GoogleMapController? mapController;
  LatLng? selectedPosition; */
  String? selectedPlaceName;

  String requestID = UUIDGenerator().uuidV4();
  // intialize _donLocationDetails

  double? reqLocationLatitude, reqLocationLongitude;
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
  }

  String _address = ''; // To store the address name
  double? _latitude; // To store latitude
  double? _longitude;
  Map<String, dynamic>? userInfos;

  Position? position;

  @override
  void initState() {
    super.initState();
    // _getCurrentUserLocation();
    getCurrentUserInfo();
  }

  void getCurrentUserInfo() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userProfileID) // Utilisation de l'UID
        .get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        userInfos = userData;
      });
    } else {
      print("An error occured.");
    }
  }

  // Fetch the address from latitude and longitude
  Future<void> _getAddressFromCoordinates(latitude, longitude) async {
    if (latitude != null && longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        Placemark place = placemarks[0];
        setState(() {
          _address =
              "${place.name}, ${place.locality}, ${place.country}"; // Formatted address
        });
      } catch (e) {
        print("Error fetching address: $e");
      }
    }
  }

  String userCurrentAddress = "No location has been selected!";
  _getCurrentUserLocation() async {
    try {
      _determinePosition().then((Position position) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
        _getAddressFromCoordinates(position.latitude, position.longitude);
      }).catchError((e) {
        print(e);
      });
    } catch (error) {
      ToastMessages().showErrorToast(error.toString());
    }
  }

  void sendSuccessCode() {
    //print("Post Add Success!");
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      isUploadComplete = true;
    });
    showAlertDialog(context);
  }

  void sendErrorCode(String error) {
    ToastMessages().showErrorToast(error);
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUploadComplete
                  ? Center(child: Text("Request Loading"))
                  : Center(child: Text("Loading completed")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUploadComplete)
                    !isAnError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade700),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text("Please your request is charging...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Error!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Try Again",
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  onClicked: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/welcome.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 30),
                            Text("The Request has been charged!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            ButtonWidget(
                                text: "Continue",
                                textColor: Colors.white,
                                color: Colors.indigo,
                                onClicked: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                }),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          },
        );
      },
    );
  }

  // add donnation to firestore with multiple images
  Future<void> addReqToFireStore() async {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(requestID)
        .set({
          'requestID': requestID,
          'userInfos': userInfos,
          'requestTitle': _controller.text,
          'quantity': _controllerQuantity.text,
          'requestDescription': _descriptionController.text,
          'requestStatus': 'Pending',
          'latitude': _latitude,
          'longitude': _longitude,
          'address': _address,
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  void validateRequest() {
    if (_controller.text.isEmpty) {
      ToastMessages().showErrorToast('Please enter a title');
    } else if (_descriptionController.text.isEmpty) {
      ToastMessages().showErrorToast('Please enter a description');
    } else if (_controllerQuantity.text.isEmpty) {
      ToastMessages().showErrorToast('Please enter a quantity');
    } else {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.8;
      });
      showAlertDialog(context);
      addReqToFireStore();
    }
  }

  final TextEditingController _descriptionController =
      TextEditingController(); // Create the controller
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Request'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the page with information about allowed food types
            },
            child: const Center(
              child: Text(
                'What type of food are allowed on Caritas?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildLocation(),
          _buildTitle(),
          _buildDescription(),
          _buildQuantity(),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                validateRequest();
              },
              child: Text('Validate Request',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 203, 152, 206),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    // Implement the food icon message widget
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text(
            'Location : ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(_address),
          trailing: Icon(Icons.location_on_sharp),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPicker(
                  onLocationPicked: (position) {
                    setState(() {
                      _latitude = position.latitude;
                      _longitude = position.longitude;
                    });
                    _getAddressFromCoordinates(
                        position.latitude, position.longitude);
                  },
                ),
              ),
            );
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _buildTitle() {
    // Implement the widget for entering the title
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            const ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Row(children: [
                  Text(
                    'Enter Food Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Add a border
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: TextField(
                controller: _controller,
                maxLength: maxTitleLength,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.all(12.0), // Add padding inside the box
                  border: InputBorder.none,
                  hintText: 'E.g. Vegetable, Cakes, Cereals',
                  counterText: '${_controller.text.length}/$maxTitleLength',
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildQuantity() {
    // Implement the widget for entering the title
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            const ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Row(children: [
                  Text(
                    'Enter Food Quantity(in Kg)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Add a border
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: TextField(
                controller: _controllerQuantity,
                maxLength: maxTitleLength,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.all(12.0), // Add padding inside the box
                  border: InputBorder.none,
                  hintText: 'E.g. 5kg, 15kg, 20kg',
                  counterText: '${_controller.text.length}/$maxTitleLength',
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildDescription() {
    // Implement the widget for entering the description
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Row(children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Add a border
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
            child: TextField(
              minLines: null,
              maxLines: null,
              controller: _descriptionController,
              maxLength: maxDescriptionLength,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.all(12.0), // Add padding inside the box
                border: InputBorder.none,
                hintText:
                    'E.g. Tomatoes from the garden,Give as many details as possible to increase your chances of giving',
                counterText: '${_controller.text.length}/$maxDescriptionLength',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
