import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class OrphanageRegistration extends StatefulWidget {
  @override
  _OrphanageRegistrationState createState() => _OrphanageRegistrationState();
}

class _OrphanageRegistrationState extends State<OrphanageRegistration> {
  final _formKey = GlobalKey<FormState>();

  String orphanageName = '';
  String description = '';
  String image = '';
  String education = '';
  String healthcare = '';
  String address = '';
  String phone = '';
  String email = '';
  File? _image;
  String? documentPath;

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

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        documentPath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Orphanage Name',
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
                    return 'Please enter orphanage name';
                  }
                  return null;
                },
                onSaved: (value) {
                  orphanageName = value!;
                },
              ),
              SizedBox(height: 16),
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
                      ? Center(child: Text('Tap to enter orphanage image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: pickDocument,
                icon: const Icon(Icons.cloud_upload),
                label: Text(documentPath == null
                    ? 'Upload Orphanage Agreement Document'
                    : 'Document: ${documentPath!.split('/').last}'),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Education',
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
                    return 'Please enter educational mission';
                  }
                  return null;
                },
                onSaved: (value) {
                  education = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Healthcare',
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
                    return 'Please enter healthcare objectives';
                  }
                  return null;
                },
                onSaved: (value) {
                  healthcare = value!;
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
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
                          content: Text(
                              'Orphanage $orphanageName has been registered!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Register Orphanage',
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
      ),
    );
  }
}
