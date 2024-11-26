import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../home.dart';
import '../Orphanage/map_picker.dart';

class RestaurantRegistration extends StatefulWidget {
  @override
  _RestaurantRegistrationState createState() => _RestaurantRegistrationState();
}

class _RestaurantRegistrationState extends State<RestaurantRegistration> {
  final _formKey = GlobalKey<FormState>();

  String restaurantName = '';
  String description = '';
  String address = '';
  String phone = '';
  String email = '';
  File? _image;
  List<String> documentPaths = [];
  String openingHours = '';
  List<String> imagePaths = [];
  LatLng? _restaurantLocation;
  String? _address = '';
  double? _latitude;
  double? _longitude;

  final picker = ImagePicker();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> pickImage() async {
    if (imagePaths.length >= 4) {
      _showSnackBar('Maximum of 4 images can be uploaded');
      return;
    }
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path);
      });
    }
  }

  Future<void> pickDocument() async {
    if (documentPaths.length >= 4) {
      _showSnackBar('Maximum of 4 documents can be uploaded');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        documentPaths.add(result.files.single.path!);
      });
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    if (_latitude != null && _longitude != null) {
      try {
        final placemarks =
            await placemarkFromCoordinates(_latitude!, _longitude!);
        setState(() {
          _address =
              "${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}";
        });
      } catch (e) {
        print("Error fetching address: $e");
      }
    }
  }

  Future<void> registerRestaurant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final restaurantData = {
        'userProfileID': user.uid,
        'restaurantName': restaurantName,
        'description': description,
        'latitude': _latitude,
        'longitude': _longitude,
        'phone': phone,
        'email': email,
        'openingHours': openingHours,
        'image': _image?.path,
        'menuImages': imagePaths,
        'documents': documentPaths,
      };

      try {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .add(restaurantData);
        _showSuccessDialog();
      } catch (e) {
        print("Failed to add restaurant: $e");
      }
    } else {
      print('No user logged in');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Successful'),
        content: Text('Restaurant $restaurantName has been registered!'),
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
      appBar: AppBar(title: Text('Restaurant Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                hint: 'Restaurant Name',
                onSaved: (value) => restaurantName = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter restaurant name'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
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
                      ? Center(child: Text('Tap to select restaurant image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              _buildTextField(
                hint: 'Opening Hours: e.g. (Mon-Fri: 10am - 10pm)',
                onSaved: (value) => openingHours = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter opening hours'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
                hint: 'Address',
                controller: TextEditingController(text: _address),
                onSaved: (value) => address = value!,
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
                          _getAddressFromCoordinates();
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                hint: 'Phone',
                onSaved: (value) => phone = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter phone number'
                    : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
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
                    registerRestaurant();
                  }
                },
                child: Text('Register Restaurant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
