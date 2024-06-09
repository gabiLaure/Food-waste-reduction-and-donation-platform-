// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:caritas/generators/uuid_generator.dart';
import 'package:caritas/home.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestDonation extends StatefulWidget {
  @override
  State<RequestDonation> createState() => _RequestDonationState();
}

class _RequestDonationState extends State<RequestDonation> {
  //String _output = '';
  String _listingType = 'Request'; // Default value

  final TextEditingController _descriptionController =
      TextEditingController(); // Create the controller
  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());
  double? circularProgressVal;
  final TextEditingController _controller = TextEditingController();
  final int maxTitleLength = 50;
  final int maxDescriptionLength = 500;

  //bool _showCalendar = true;
  // Holds the selected action
  String selectedAction = 'Request';
  DateTime? selectedDate;
  bool isSwitched = false;
  bool isAnError = false;
  bool isDonCreated = false;
  bool isStartToCreate = false;
  String donationID = UUIDGenerator().uuidV4();

  void sendErrorCode(String error) {
    ToastMessages().showErrorToast(error);
    Navigator.pop(context);
    //print("Post Add Error!");

    setState(() {
      isStartToCreate = false;
      isAnError = true;
      isDonCreated = false;
      showAlertDialog(context);
    });
  }

  void sendSuccessCode() {
    //print("Post Add Success!");
    Navigator.pop(context);
    setState(() {
      isStartToCreate = false;
      isDonCreated = true;
    });
    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: !isDonCreated
                  ? Center(child: Text("Creation de la demande"))
                  : Center(child: Text("")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isDonCreated)
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
                                    Colors.indigo),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Veuillez patienter...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Error!",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Réessayez"),
                              ),
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
                            Text("Requête de don créé!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text("Continue"))
                          ],
                        ),
                      ),
                    )
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          });
        });
  }

  // void ifAnError() {
  //   Navigator.pop(context);
  //   setState(() {
  //     isDonCreated = false;
  //     isAnError = true;
  //     //Navigator.pop(context);
  //     showAlertDialog(context);
  //   });
  // }

  void validateRequest() {
    if (_controller.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _listingType.isEmpty) {
      ToastMessages().showInfoToast("Remplissez tous les champs");
    } else {
      addReqDonToFireStore();
    }
  }

  // add request donation to firestore
  Future<void> addReqDonToFireStore() async {
    // add request donation to firestore
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userProfileID)
        .collection('donations')
        .doc(donationID)
        .set({
          'donationID': donationID,
          'userProfileID': userProfileID,
          'listingType': _listingType,
          'title': _controller.text,
          'description': _descriptionController.text,
          'requestdate': "$formattedDate, $formattedTime",
          'status': 'Pending',
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
    // setState(() {
    //   isDonCreated = true;
    //   isAnError = false;
    //   //Navigator.pop(context);
    //   showAlertDialog(context);
    // }
    // );
  }

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
          SizedBox(height: 24),
          _buildListingType(),
          _buildTitle(),
          _buildDescription(),
          //_buildAvailabilities(),
          //Divider(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              addReqDonToFireStore();
              // print(userProfileID);
              // print(_controller.text);
              // print(_descriptionController.text);
              // print(_listingType);
              // Validate and submit all responses
            },
            child: Text('Validate Request'),
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
}
