import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final String userProfileID =
      FirebaseAuth.instance.currentUser!.uid.toString();

  String restaurantName = '';
  String description = '';
  String address = '';
  String phone = '';
  String email = '';
  File? _image;
  List<String> documentPaths = [];
  List<String> imagePaths = [];
  String openingHours = '';
  LatLng? _restaurantLocation;
  String? _address = '';
  double? _latitude;
  double? _longitude;
  List<File> _selectedImages = [];

  final picker = ImagePicker();

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

  Future<void> uploadImageToStorage() async {
    List<String> imageList = [];
    try {
      // Ensure no duplicate images in the list
      _selectedImages = _selectedImages.toSet().toList();

      for (var image in _selectedImages) {
        // Generate a unique path for each image
        final ref = FirebaseStorage.instance.ref().child(
            'restaurant_images/$userProfileID/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

        // Upload the image to Firebase Storage
        await ref.putFile(image);

        // Get the download URL
        final imageUrl = await ref.getDownloadURL();
        // Add the URL to the list
        imageList.add(imageUrl);
      }

      // Save the image list to Firestore
      _uploadAndRegister(imageList);

      // Clear the selected images after uploading
      _selectedImages.clear();
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

  Future<void> _uploadAndRegister(imageList) async {
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
      registerRestaurant(imageList, imageUrl);
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

  Future<void> registerRestaurant(imageList, imageUrl) async {
    final restaurantData = {
      'userProfileID': userProfileID,
      'restaurantName': restaurantNameController.text,
      'description': descriptionController.text,
      'latitude': _latitude,
      'longitude': _longitude,
      'phone': phoneController.text,
      'email': emailController.text,
      'openingHours': openingHours,
      'image': imageUrl,
      'menuImages': imageList,
      'address': _address
    };

    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .add(restaurantData);
      _showSuccessDialog();
    } catch (e) {
      print("Failed to add restaurant: $e");
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
                controller: restaurantNameController,
                hint: 'Restaurant Name',
                onSaved: (value) => restaurantName = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter restaurant name'
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
                      ? Center(child: Text('Tap to select restaurant image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              _buildPhotosContainer(),
              SizedBox(height: 16),
              SizedBox(height: 16),
              _buildTextField(
                controller: TextEditingController(
                    text: _address), // _address holds the name of the area
                hint: 'Address',
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
                    uploadImageToStorage();
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

  Widget _buildPhotosContainer() {
    // Implement the widget for selecting/uploading photos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
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
}
