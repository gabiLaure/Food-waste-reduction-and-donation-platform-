// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/generators/uuid_generator.dart';
import 'package:caritas/home.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/what_type_of_food.dart';
import '../Orphanage/map_picker.dart';

class ListingCreationPage extends StatefulWidget {
  @override
  State<ListingCreationPage> createState() => _ListingCreationPageState();
}

class _ListingCreationPageState extends State<ListingCreationPage> {
  //String _output = '';
  //late LatLng _selectedLocation;

  List<Map<String, dynamic>> orphanages = [];

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

  List<File> _selectedImages = [];
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String donationID = UUIDGenerator().uuidV4();
  // intialize _donLocationDetails

  double? donLocationLatitude, donLocationLongitude;
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
  double? _distanceBetweenUs;
  Map<String, dynamic>? userInfos;

  Map<String, dynamic>? selectedOrphanage; // Stocke l'orphelinat sélectionné
  Position? position;

  @override
  void initState() {
    super.initState();
    // _getCurrentUserLocation();
    fetchOrphanages();
    getCurrentUserInfo();
  }

  void getCurrentUserInfo() async {
    setState(() {
      userInfos = GlobalData.userData;
    });
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

  Future<void> fetchOrphanages() async {
    Map<String, dynamic> allCommunity = {
      'id': 'all-community',
      'name': 'All Community',
      'latitude': 0.0, // Pas de latitude pour "All Community"
      'longitude': 0.0, // Pas de longitude pour "All Community"
    };
    try {
      // Requête Firestore pour récupérer les orphelinats
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orphanages') // Nom de la collection des orphelinats
          .get();

      // Extraire les noms des orphelinats et leurs ID depuis le document
      List<Map<String, dynamic>> fetchedOrphanages = querySnapshot.docs
          .map((doc) => {
                'name': doc['orphanageName'] as String, // Nom de l'orphelinat
                'id': doc.id, // ID du document
                'latitude': doc['latitude'],
                'longitude': doc['longitude']
              })
          .toList();

      // Mettre à jour l'état avec les orphelinats récupérés
      setState(() {
        orphanages = [allCommunity, ...fetchedOrphanages];
      });
    } catch (e) {
      print("Error fetching orphanages: $e");
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

  void _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (_selectedImages.length < 4) {
          _selectedImages.add(File(pickedFile.path));
        }
      });
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
    //print("Post Add Error!");

    setState(() {
      isStartToUpload = false;
      isAnError = true;
      isUploadComplete = true;
    });
    showAlertDialog(context);
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
                  ? Center(child: Text("Donation Loading"))
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
                              Text("Please your donation is charging...",
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
                            Text("The Donation has been charged!",
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

  Future<void> uploadImageToStorage() async {
    List<String> imageList = [];
    try {
      // Ensure no duplicate images in the list
      _selectedImages = _selectedImages.toSet().toList();

      for (var image in _selectedImages) {
        // Generate a unique path for each image
        final ref = firebase_storage.FirebaseStorage.instance.ref().child(
            'donation_images/$userProfileID/$donationID/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

        // Upload the image to Firebase Storage
        await ref.putFile(image);

        // Get the download URL
        final imageUrl = await ref.getDownloadURL();
        // Add the URL to the list
        imageList.add(imageUrl);
      }

      // Save the image list to Firestore
      addDonToFireStore(imageList);

      // Clear the selected images after uploading
      _selectedImages.clear();
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

  // add donnation to firestore with multiple images
  Future<void> addDonToFireStore(List<String> imageList) async {
    FirebaseFirestore.instance
        .collection('donations')
        .doc(donationID)
        .set({
          'donationID': donationID,
          'userInfos': userInfos,
          'orphanage': selectedOrphanage,
          'donationTitle': _controller.text,
          'quantity': _controllerQuantity.text,
          'donationDescription': _descriptionController.text,
          'donationDate': "$formattedDate, $formattedTime",
          'donationImages': imageList,
          'donationStatus': 'Pending',
          'donationBestBefore': selectedDate,
          'donationAvailability': selectedAction,
          'latitude': _latitude,
          'longitude': _longitude,
          'distanceBetweenUs': _distanceBetweenUs
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  void validateDonation() {
    if (_selectedImages.isEmpty) {
      ToastMessages().showErrorToast('Please select at least one image');
    } else if (_controller.text.isEmpty) {
      ToastMessages().showErrorToast('Please enter a title');
    } else if (_descriptionController.text.isEmpty) {
      ToastMessages().showErrorToast('Please enter a description');
    } else if (selectedAction.isEmpty) {
      ToastMessages().showErrorToast('Please select an availability');
    } else if (selectedDate == null) {
      ToastMessages().showErrorToast('Please select a best before date');
    } else {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.8;
      });
      showAlertDialog(context);
      uploadImageToStorage();
    }
  }

  final TextEditingController _descriptionController =
      TextEditingController(); // Create the controller

  // Méthode pour calculer la distance entre deux points géographiques en mètres
  double calculateDistance(double currentLatitude, double currentLongitude,
      double communityLatitude, double communityLongitude) {
    if (currentLatitude != 0.0 &&
        currentLongitude != 0.0 &&
        communityLatitude != 0.0 &&
        communityLongitude != 0.0) {
      final distanceInMeters = Geolocator.distanceBetween(currentLatitude,
          currentLongitude, communityLatitude, communityLongitude);

      return distanceInMeters / 1000;
    }
    return 0.0;
  }

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 500;

  //bool _showCalendar = true;
  // Holds the selected action
  String selectedAction = '';
  DateTime? selectedDate;
  bool isSwitched = false;

  // @override
  // void initState() {
  //   _getCurrentUserLocation();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // Vérifie si _distanceBetweenUs est null, si c'est le cas, on montre un message
    if (_distanceBetweenUs == null) {
      return _buildScaffoldWithMessage('');
    }

    if (selectedOrphanage!['name'] == 'All Community') {
      return _buildScaffoldWithDetailsForAll();
    } else {
      // Si _distanceBetweenUs est inférieur à 20 km, affiche les informations détaillées
      if (_distanceBetweenUs! < 20) {
        return _buildScaffoldWithDetails();
      } else {
        // Si la distance est supérieure à 20 km, affiche un message
        return _buildScaffoldWithMessage(
            'Distance is too far donations are permitted within a distance of less than 20km');
      }
    }
  }

  Widget _buildScaffoldWithDetailsForAll() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Donation'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the page with information about allowed food types
            },
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the WhatTypeOfFoodPage when the text is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WhatTypeOfFoodPage()),
                  );
                },
                child: Text(
                  'What type of food are allowed on Caritas?',
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildLocation(),
          orphanages.isNotEmpty
              ? _buildLocalCommunity(orphanages)
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
          _buildPhotosContainer(),
          _buildTitle(),
          _buildDescription(),
          _buildQuantity(),
          _buildAvailabilities(),
          Divider(),
          _buildBestBefore(),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                validateDonation();
              },
              child: Text('Validate Donation',
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

  Widget _buildScaffoldWithDetails() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Donation'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the WhatTypeOfFoodPage when the text is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WhatTypeOfFoodPage()),
              );
            },
            child: Center(
              child: Text(
                'What type of food are allowed on Caritas?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildLocation(),
          orphanages.isNotEmpty
              ? _buildLocalCommunity(orphanages)
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
          _displayDistance(),
          _buildPhotosContainer(),
          _buildTitle(),
          _buildDescription(),
          _buildQuantity(),
          _buildAvailabilities(),
          Divider(),
          _buildBestBefore(),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                validateDonation();
              },
              child: Text('Validate Donation',
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

  Widget _buildScaffoldWithMessage(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Donation'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the WhatTypeOfFoodPage when the text is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WhatTypeOfFoodPage()),
              );
            },
            child: const Center(
              child: Text(
                'What type of food are allowed on Caritas?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(height: 24),
          _buildLocation(),
          orphanages.isNotEmpty
              ? _buildLocalCommunity(orphanages)
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
          _displayDistance(),
          Center(
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalCommunity(List<Map<String, dynamic>> orphanages) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: selectedOrphanage,
      onChanged: (newValue) {
        setState(() {
          selectedOrphanage = newValue!;

          // Logique pour "All Community"
          if (newValue['name'] == 'All Community') {
            _distanceBetweenUs =
                0.0; // Pas de calcul de distance pour "All Community"
          } else {
            // Calculer la distance pour les autres communautés

            _distanceBetweenUs = calculateDistance(
              _latitude!,
              _longitude!,
              newValue['latitude'],
              newValue['longitude'],
            );
          }
        });
      },
      items: orphanages.map((Map<String, dynamic> orphanage) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: orphanage,
          child: Text(orphanage['name']),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Local Community',
        border: OutlineInputBorder(),
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
                      _latitude = position.latitude; // Store latitude
                      _longitude = position.longitude; // Store longitude
                      if (selectedOrphanage != null) {
                        _distanceBetweenUs = calculateDistance(
                            position.latitude,
                            position.longitude,
                            selectedOrphanage!['latitude'],
                            selectedOrphanage!['longitude']);
                      }
                    });
                    _getAddressFromCoordinates(position.latitude,
                        position.longitude); // Get address from coordinates
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

  Widget _buildPhotosContainer() {
    // Implement the widget for selecting/uploading photos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Row(children: [
              Text(
                'Food Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])),
        SizedBox(height: 8),
        _buildSelectedImages(),
        SizedBox(height: 8),
        Visibility(
          visible: _selectedImages.length < 4,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 100), // Set the desired size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ), // Rounded corners
            onPressed: () {
              _showImageSourceDialog();
            },
            icon: Icon(Icons.add), // Icon in the center
            label: Text('Add food Image'),
          ),
        ),
        Visibility(
          visible: _selectedImages.length == 4,
          child: Text(
            'You can add a maximum of 4 photos.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImages() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedImages.map((image) {
        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.remove(image);
                  });
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Select Image Source')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
                child: Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
                child: const Text('Choose from Gallery'),
              ),
            ],
          ),
        );
      },
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Widget _buildAvailabilities() {
    // Implement the widget for selecting availabilities
    return ListTile(
        leading: Icon(Icons.check_circle_outline),
        title: Row(
          children: [
            Text(
              'Avalaibility : ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(selectedAction)
          ],
        ),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () {
          // Navigate to the listing creation page for donation
          setState(() {
            _showModalBottomSheet();
          });
        });
  }

  void _showModalBottomSheet() {
    final options = [
      'Week Days',
      'Week Evening',
      'Weekend',
      'I am available',
      'Cancel',
    ];

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(), // Add a divider below the heading
          ...options.map((option) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(option),
                  onTap: () {
                    if (option != 'Cancel') {
                      setState(() {
                        selectedAction = option;
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                Divider(),
              ],
            );
          }).toList(),
        ]);
      },
    );
  }

  Widget _buildBestBefore() {
    // Implement the food icon message widget
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text(
            'Best Before : ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
              selectedDate != null ? selectedDate.toString() : 'Select a date'),
          trailing: Icon(Icons.calendar_today),
          onTap: () {
            _showDatePicker(context);
          },
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(
              title: Center(
                child: Text(
                  'Select Expiration Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: Text(
                'Done',
                style: TextStyle(color: Colors.blue),
              )),
          Divider(),
          Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          )
        ]);
      },
    );
  }

  Widget _displayDistance() {
    // Vérifie si les coordonnées et l'orphelinat sélectionné sont disponibles
    if (_distanceBetweenUs == null || _distanceBetweenUs == 0.0) {
      return SizedBox
          .shrink(); // Retourne un widget vide si les conditions ne sont pas remplies
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.map),
            title: Text(
              'Distance to Selected Orphanage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${_distanceBetweenUs!.toStringAsFixed(2)} kilometers',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
