import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class GroceryRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Registration'),
      ),
      body: GroceryRegistrationForm(),
    );
  }
}

class GroceryRegistrationForm extends StatefulWidget {
  @override
  _GroceryRegistrationFormState createState() =>
      _GroceryRegistrationFormState();
}

class _GroceryRegistrationFormState extends State<GroceryRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String storeName = '';
  String description = '';
  String address = '';
  String phone = '';
  String email = '';
  File? _image;
  String openingHours = ''; // State variable to hold opening hours input

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Store Name',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter store name';
                }
                return null;
              },
              onSaved: (value) {
                storeName = value!;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
              onSaved: (value) {
                description = value!;
              },
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
                    ? Center(child: Text('Tap to select Superette image'))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Opening Hours: ex (Mon-Fri: 10am -10pm)',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter opening hours';
                }
                return null;
              },
              onSaved: (value) {
                openingHours = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Address',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
              onSaved: (value) {
                address = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Phone',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
              onSaved: (value) {
                phone = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: GoogleFonts.crimsonPro(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 14.0,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    width: 0.2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 203, 152, 206),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Here you can handle the form data as needed
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Registration Successful'),
                        content: Text('Grocery $name has been registered!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Register Grocery',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 203, 152, 206),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
