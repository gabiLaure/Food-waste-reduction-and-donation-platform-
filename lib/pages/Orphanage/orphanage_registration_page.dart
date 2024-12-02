import 'dart:io';
import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/pages/Orphanage/map_picker.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

import '../../generators/uuid_generator.dart';
import '../../home.dart'; // Import geocoding

class OrphanageRegistration extends StatefulWidget {
  @override
  _OrphanageRegistrationState createState() => _OrphanageRegistrationState();
}

LatLng? _orphanageLocation;
String? _address = ''; // To store the address name
double? _latitude; // To store latitude
double? _longitude;
double? circularProgressVal;
bool isUploadComplete = false;
bool isAnError = false;
bool isStartToUpload = false;

final String userProfileID = FirebaseAuth.instance.currentUser!.uid.toString();
// final UserCredential userCredential;
// To store longitude
String donationID = UUIDGenerator().uuidV4();

class _OrphanageRegistrationState extends State<OrphanageRegistration> {
  TextEditingController orphanageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String orphanageName = '',
      description = '',
      education = '',
      healthcare = '',
      address = '',
      phone = '',
      email = '';
  File? _image;
  String? documentPath;
  final picker = ImagePicker();

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
                  ? Center(child: Text("Orphanage Registration Loading"))
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
                              Text("Please your Orphanage is been created...",
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
                            Text("The Orphanage has been created!",
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

  bool validateOrphanage() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.8;
      });
      showAlertDialog(context);
      _uploadAndRegister();
    }
    return true;
  }

  void showMessageError() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.8;
      });
      showAlertDialog(context);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() => _image = pickedFile != null ? File(pickedFile.path) : null);
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (result != null) setState(() => documentPath = result.files.single.path);
  }

  Future<void> _uploadAndRegister() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    try {
      // Upload image
      String? imageUrl;
      if (_image != null) {
        final imageRef = FirebaseStorage.instance
            .ref()
            .child('images/${_image!.path.split('/').last}');
        await imageRef.putFile(_image!);
        imageUrl = await imageRef.getDownloadURL();
      }

      // Upload document
      String? documentUrl;
      if (documentPath != null) {
        final documentRef = FirebaseStorage.instance
            .ref()
            .child('documents/${documentPath!.split('/').last}');
        await documentRef.putFile(File(documentPath!));
        documentUrl = await documentRef.getDownloadURL();
      }
      final orphanage = {
        'orphanageName': orphanageController.text.trim(),
        'latitude': _latitude,
        'longitude': _longitude,
        'description': descriptionController.text.trim(),
        'education': education,
        'healthcare': healthcare,
        'address': address,
        'phone': phone,
        'email': email,
        'imageUrl': imageUrl,
        'documentUrl': documentUrl,
        'userProfileID': userProfileID
      };

      // Save data to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('orphanages')
          .add(orphanage);
      // Récupération de l'ID du document
      String documentId = docRef.id;

      // Mise à jour de l'objet avec l'ID du document
      orphanage['id'] = documentId;

      // Enregistrement dans GlobalData
      GlobalData.orphanageData = orphanage;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text(
              'Orphanage $orphanageName has been successfully registered!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()), // Go to home page
                  );
                },
                child: const Text('OK'))
          ],
        ),
      );
    } catch (e) {
      print("Error uploading data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading data')));
    }
  }

  // Fetch the address from latitude and longitude
  Future<void> _getAddressFromCoordinates() async {
    if (_latitude != null && _longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(_latitude!, _longitude!);
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

  @override
  Widget build(BuildContext context) {
    InputDecoration fieldDecoration(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.crimsonPro(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(width: 0.2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 203, 152, 206)),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text('Orphanage Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: orphanageController,
                decoration: fieldDecoration('Orphanage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },

                //   decoration: fieldDecoration('Orphanage Name'),
                //   validator: (value) => value == null || value.isEmpty
                //       ? 'Please enter the orphanage name'
                //       : null,
                //   onSaved: (value) => orphanageName = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: fieldDecoration('Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Education Level'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the education level offered'
                    : null,
                onSaved: (value) => education = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Healthcare Services'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter healthcare services offered'
                    : null,
                onSaved: (value) => healthcare = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                    text: _address), // _address holds the name of the area
                decoration: fieldDecoration('Address'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the address'
                    : null,
                onSaved: (value) => address = value!,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPicker(
                        onLocationPicked: (position) {
                          setState(() {
                            _latitude = position.latitude; // Store latitude
                            _longitude = position.longitude; // Store longitude
                          });
                          _getAddressFromCoordinates(); // Get address from coordinates
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Phone Number'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the phone number'
                    : null,
                onSaved: (value) => phone = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Email Address'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the email address'
                    : null,
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _image == null
                      ? Center(child: Text('Tap to add an orphanage image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: pickDocument,
                icon: const Icon(Icons.cloud_upload),
                label: Text(documentPath == null
                    ? 'Upload Agreement Document'
                    : 'Document: ${documentPath!.split('/').last}'),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _uploadAndRegister,
                  child: Text('Register Orphanage',
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
        ),
      ),
    );
  }
}
