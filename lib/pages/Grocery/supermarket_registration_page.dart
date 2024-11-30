import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../admin/models/global_data.dart';
import '../../home.dart';
import '../../widgets/local_community.dart';
import '../../widgets/toast_messages.dart';
import '../Orphanage/map_picker.dart';

class GroceryRegistration extends StatefulWidget {
  @override
  _GroceryRegistrationState createState() => _GroceryRegistrationState();
}

class _GroceryRegistrationState extends State<GroceryRegistration> {
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
  String? _address = '';
  double? _latitude;
  double? _longitude;
  String openingHours = '';

  // State variable to hold opening hours input
  File? _image;
  List<String> imagePaths = [];

  final picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = pickedFile != null ? File(pickedFile.path) : null;
  //   });
  // }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print("Image picked: ${pickedFile.path}");
      } else {
        print("No image selected");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
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
          .collection('supermarkets')
          .add(supermarketData);
      _showSuccessDialog();
      // Récupération de l'ID du document
      String documentId = docRef.id;

      // Mise à jour de l'objet avec l'ID du document
      supermarketData['id'] = documentId;

      // Enregistrement dans GlobalData
      GlobalData.orphanageData = supermarketData;
    } catch (e) {
      print("Failed to add supermarket: $e");
      ToastMessages().showErrorToast('Failed to add restaurant');
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: TextEditingController(
                      text: _address), // _address holds the name of the area
                  hint: 'Address',
                  onSaved: (value) => _address = value!,
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
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _uploadAndRegister();
                      }
                    },
                    child: Text('Register Supermarket',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
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
        ));
  }
}
