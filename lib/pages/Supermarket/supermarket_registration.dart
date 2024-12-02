import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../admin/models/global_data.dart';
import '../../../home.dart';
import '../../../widgets/button_widgets.dart';
import '../../../widgets/toast_messages.dart';
import '../Orphanage/map_picker.dart';

class SupermarketRegistration extends StatefulWidget {
  @override
  _SupermarketRegistrationState createState() =>
      _SupermarketRegistrationState();
}

class _SupermarketRegistrationState extends State<SupermarketRegistration> {
  final TextEditingController _controller = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController supermarketNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController openingHoursController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();

// Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double? circularProgressVal;

  String supermarketName = '';
  String description = '';
  String address = '';
  String phone = '';
  String email = '';
  File? _image;
  String openingHours = '';
  LatLng? _supermarketLocation;
  String? _address = '';
  double? _latitude;
  double? _longitude;

  final picker = ImagePicker();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                  ? Center(child: Text("Registration Loading"))
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
                              Text("Please your Supermarket is charging...",
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
                            Text("The Supermarket has been charged!",
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

  void validateSupermarket() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.8;
      });
      showAlertDialog(context);
      _uploadAndRegister();
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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadAndRegister() async {
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

      // Save data to Firestore
      registerSupermarket(imageUrl);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading data')));
    }
  }

  Future<void> _getAddressFromCoordinates(latitude, longitude) async {
    if (latitude != null && longitude != null) {
      try {
        final placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        setState(() {
          _address =
              "${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}";
        });
      } catch (e) {
        print("Error fetching address: $e");
      }
    }
  }

  Future<void> registerSupermarket(imageUrl) async {
    final supermarketData = {
      'userProfileID': userProfileID,
      'supermarketName': supermarketNameController.text,
      'description': descriptionController.text,
      'latitude': _latitude,
      'longitude': _longitude,
      'phone': phoneController.text,
      'email': emailController.text,
      'openingHours': openingHours,
      'image': imageUrl,
      'address': _address
    };

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('supermarket')
          .add(supermarketData);
      sendSuccessCode();

      // Récupération de l'ID du document
      String documentId = docRef.id;

      // Mise à jour de l'objet avec l'ID du document
      supermarketData['id'] = documentId;

      // Enregistrement dans GlobalData
      GlobalData.orphanageData = supermarketData;
    } catch (e) {
      print("Failed to add supermarket: $e");
      ToastMessages().showErrorToast('Failed to add supermarket');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Successful'),
        content: Text('Supermarket $supermarketName has been registered!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
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

  Widget _buildTextField({
    required String hint,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    TextEditingController? controller,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      decoration: _fieldDecoration(hint),
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supermarket Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: supermarketNameController,
                hint: 'Supermarket Name',
                onSaved: (value) => supermarketName = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter supermarket name'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                hint: 'Description',
                onSaved: (value) => description = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter description'
                    : null,
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
                      ? Center(child: Text('Tap to select supermarket image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: TextEditingController(
                    text: _address), // _address holds the name of the area
                hint: 'Address',
                onSaved: (value) => address = value!,
                onTap: () async {
                  await Navigator.push(
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
              SizedBox(height: 16),
              _buildTextField(
                controller: openingHoursController,
                hint: 'Opening Hours',
                onSaved: (value) => openingHours = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Opening Hours'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: phoneController,
                hint: 'Phone',
                onSaved: (value) => phone = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter phone number'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                hint: 'Email',
                onSaved: (value) => email = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter email'
                    : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    validateSupermarket();
                  }
                },
                child: Text('Register Supermarket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
