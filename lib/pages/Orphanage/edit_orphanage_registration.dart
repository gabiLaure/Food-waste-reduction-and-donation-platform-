import 'dart:io';
import 'package:caritas/pages/Orphanage/map_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

import '../../home.dart'; // Import geocoding

class OrphanageEdit extends StatefulWidget {
  final String orphanageId; // Pass the orphanage ID to fetch the data

  OrphanageEdit({required this.orphanageId});

  @override
  _OrphanageEditState createState() => _OrphanageEditState();
}

LatLng? _orphanageLocation;
String? _address = ''; // To store the address name
double? _latitude; // To store latitude
double? _longitude;

final String userProfileID = FirebaseAuth.instance.currentUser!.uid.toString();

class _OrphanageEditState extends State<OrphanageEdit> {
  TextEditingController orphanageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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

  // Fetch orphanage details from Firestore
  Future<void> _loadOrphanageData() async {
    try {
      DocumentSnapshot orphanageSnapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .doc(widget.orphanageId)
          .get();
      if (orphanageSnapshot.exists) {
        var orphanageData = orphanageSnapshot.data() as Map<String, dynamic>;

        setState(() {
          orphanageController.text = orphanageData['orphanageName'];
          descriptionController.text = orphanageData['description'];
          addressController.text = orphanageData['address'];
          _latitude = orphanageData['latitude'];
          _longitude = orphanageData['longitude'];
          _address = orphanageData['address'];
          phone = orphanageData['phone'];
          email = orphanageData['email'];
          education = orphanageData['education'];
          healthcare = orphanageData['healthcare'];
        });
        _getAddressFromCoordinates(); // To update the address based on lat, long
      }
    } catch (e) {
      print("Error loading orphanage data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrphanageData(); // Load data when the page is initialized
  }

  // Update orphanage data
  Future<void> _updateOrphanage() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    try {
      // Upload image if updated
      String? imageUrl;
      if (_image != null) {
        final imageRef = FirebaseStorage.instance
            .ref()
            .child('images/${_image!.path.split('/').last}');
        await imageRef.putFile(_image!);
        imageUrl = await imageRef.getDownloadURL();
      }

      // Upload document if updated
      String? documentUrl;
      if (documentPath != null) {
        final documentRef = FirebaseStorage.instance
            .ref()
            .child('documents/${documentPath!.split('/').last}');
        await documentRef.putFile(File(documentPath!));
        documentUrl = await documentRef.getDownloadURL();
      }

      // Update data in Firestore
      await FirebaseFirestore.instance
          .collection('orphanages')
          .doc(widget.orphanageId)
          .update({
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
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Successful'),
          content:
              Text('Orphanage $orphanageName has been successfully updated!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error updating data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating data')));
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
      appBar: AppBar(title: Text('Edit Orphanage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: orphanageController,
                decoration: InputDecoration(labelText: 'Orphanage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter orphanage name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Education Level'),
                initialValue: education,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the education level offered'
                    : null,
                onSaved: (value) => education = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: fieldDecoration('Healthcare Services'),
                initialValue: healthcare,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter healthcare services offered'
                    : null,
                onSaved: (value) => healthcare = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(text: _address),
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
              TextFormField(
                initialValue: phone,
                decoration: fieldDecoration('Phone Number'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter phone number'
                    : null,
                onSaved: (value) => phone = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                decoration: fieldDecoration('Email Address'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter email address'
                    : null,
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateOrphanage,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
