// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
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
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_cupernino_bottom_sheet/flutter_cupernino_bottom_sheet.dart';
import 'package:intl/intl.dart';

class ListingCreationPage extends StatefulWidget {
  @override
  State<ListingCreationPage> createState() => _ListingCreationPageState();
}

class _ListingCreationPageState extends State<ListingCreationPage> {
  //String _output = '';
  String _listingType = 'Donation'; // Default value
  String _communityType = 'DORCAS Foundation'; // Default value
  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double? circularProgressVal;
  List<File> _selectedImages = [];
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String donationID = UUIDGenerator().uuidV4();

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
                  ? Center(child: Text("chargement du message"))
                  : Center(child: Text("Chargement réussi")),
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
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade700),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                  "Veuillez attendre que votre message soit téléchargé.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Erreur!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Réessayer",
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
                            Text("Le message a été chargé!",
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
      for (var image in _selectedImages) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('donation_images/$userProfileID/$donationID');
        await ref.putFile(image);
        final imageUrl = await ref.getDownloadURL();
        print("image URL: $imageUrl");
        imageList.add(imageUrl);
        // addDonToFireStore(imageUrl);
      }
      // add donnation to firestore with list of images
      addDonToFireStore(imageList);
    } catch (e) {
      print(e);
    }
  }

  // add donnation to firestore with multiple images
  Future<void> addDonToFireStore(List<String> imageList) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userProfileID)
        .collection('donations')
        .doc(donationID)
        .set({
          'donationID': donationID,
          // 'donorID': userProfileID,
          'donationType': _listingType,
          'communityType': _communityType,
          'donationTitle': _controller.text,
          'donationDescription': _descriptionController.text,
          'donationDate': "$formattedDate, $formattedTime",
          'donationImages': imageList,
          'donationStatus': 'Pending',
          'donationBestBefore': selectedDate,
          'donationAvailability': selectedAction,
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
        circularProgressVal = 0.1;
      });
      showAlertDialog(context);
      uploadImageToStorage();
    }
  }
  // Future<void> addDonToFireStore(String imageUrl) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('donations').doc(donationID).set({
  //       'donationID': donationID,
  //       'donorID': userProfileID,
  //       'donationType': _listingType,
  //       'communityType': _communityType,
  //       'donationTitle': _controller.text,
  //       'donationDescription': _descriptionController.text,
  //       'donationDate': formattedDate,
  //       'donationTime': formattedTime,
  //       'donationLocation': 'Kigali',
  //       'donationImages': imageUrl,
  //       'donationStatus': 'Pending',
  //       'donationBestBefore': selectedDate,
  //       'donationAvailability': selectedAction,
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  final TextEditingController _descriptionController =
      TextEditingController(); // Create the controller

  final TextEditingController _controller = TextEditingController();
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 500;

  //bool _showCalendar = true;
  // Holds the selected action
  String selectedAction = '';
  DateTime? selectedDate;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Creation'),
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
          _buildListingType(),
          SizedBox(height: 24),
          _buildLocalCommunity(),
          SizedBox(height: 16),
          _buildLocation(),

          _buildPhotosContainer(),
          //_buildSelectedImages(),
          // _buildLocationSelectionButton(context),
          _buildTitle(),
          _buildDescription(),
          _buildAvailabilities(),
          Divider(),
          _buildBestBefore(),
          _buildFoodIcon(),
          _buildMerchantSwitch(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              validateDonation();
              // Validate and submit all responses
            },
            child: Text('Validate Donation'),
          ),
        ],
      ),
    );
  }

  Widget _buildListingType() {
    // Implement the widget for selecting the listing type
    return DropdownButtonFormField<String>(
      value: _listingType,
      onChanged: (newValue) {
        setState(() {
          _listingType = newValue!;
        });
      },
      items: <String>['Donation', 'Request'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Listing Type',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLocalCommunity() {
    // Implement the widget for selecting the listing type
    return DropdownButtonFormField<String>(
      value: _communityType,
      onChanged: (newValue) {
        setState(() {
          _communityType = newValue!;
        });
      },
      items: <String>[
        'CEPREJED',
        'ONDAPA',
        'DORCAS Foundation',
        'MSDAC',
        'Fondation des Enfants Orphelins'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
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
          subtitle: Text(selectedDate != null
              ? selectedDate.toString()
              : 'Select location'),
          trailing: Icon(Icons.location_on_sharp),
          onTap: () {
            _showDatePicker(context);
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
                'Photos of the Food',
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
            label: Text('Add Image'),
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

//
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
                    'Enter Ad Title',
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
        Divider(),
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

  Widget _buildFoodIcon() {
    // Implement the merchant switch widget
    return const Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
          ),
          title: Row(
            children: [
              Icon(
                Icons.fastfood_outlined,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Food',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildMerchantSwitch() {
    // Implement the merchant switch widget
    return ListTile(
      leading: Icon(Icons.check_circle_outline),
      title: Text(
        'I am a merchant',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value; // Update the state when switched
          });
        },
      ),
    );
  }
}
