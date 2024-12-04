import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

  String accountTypeName = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  void _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          setState(() {
            fullNameController.text = userData['fullname'] ?? '';
            phoneController.text = userData['phone'] ?? '';
            emailController.text = userData['email'] ?? '';
            accountTypeName = userData['accountType'] ?? '';
          });

          // Fetch additional data based on account type
          _fetchAccountTypeSpecificData(userData['accountType']);
        }
      }
    }
  }

  // Fetch additional data based on the account type (Orphanage, Restaurant, Supermarket)
  void _fetchAccountTypeSpecificData(String accountType) async {
    // Example: Fetching orphanage, restaurant, or supermarket details
    if (accountType == 'Orphanage') {
      // Fetch orphanage-specific data
      DocumentSnapshot orphanageData = await FirebaseFirestore.instance
          .collection('Orphanages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      additionalInfoController.text = orphanageData['donationFrequency'] ?? '';
    } else if (accountType == 'Restaurant') {
      // Fetch restaurant-specific data
      DocumentSnapshot restaurantData = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      additionalInfoController.text = restaurantData['cuisineType'] ?? '';
    } else if (accountType == 'Supermarket') {
      // Fetch supermarket-specific data
      DocumentSnapshot supermarketData = await FirebaseFirestore.instance
          .collection('Supermarkets')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      additionalInfoController.text = supermarketData['location'] ?? '';
    }
  }

  // Save updated user details to Firestore
  void _saveProfileChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Save general user profile data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'fullname': fullNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'accountType': accountTypeName, // Account type is not editable
        });

        // Save account-type-specific data
        if (accountTypeName == 'Orphanage') {
          await FirebaseFirestore.instance
              .collection('orphanages')
              .doc(currentUser.uid)
              .update({
            'donationFrequency': additionalInfoController.text.trim(),
          });
        } else if (accountTypeName == 'restaurant') {
          await FirebaseFirestore.instance
              .collection('Restaurants')
              .doc(currentUser.uid)
              .update({
            'cuisineType': additionalInfoController.text.trim(),
          });
        } else if (accountTypeName == 'Supermarket') {
          await FirebaseFirestore.instance
              .collection('Supermarkets')
              .doc(currentUser.uid)
              .update({
            'location': additionalInfoController.text.trim(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email (read-only for now)
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  readOnly: true,
                ),
                SizedBox(height: 16),

                // Account Type (read-only dropdown)
                DropdownButtonFormField<String>(
                  value: accountTypeName.isEmpty ? null : accountTypeName,
                  items: [
                    DropdownMenuItem(
                        value: accountTypeName,
                        child: Text(accountTypeName.isEmpty
                            ? 'Loading...'
                            : accountTypeName))
                  ],
                  onChanged: null, // Disable editing of account type
                  decoration: InputDecoration(labelText: 'Account Type'),
                ),
                SizedBox(height: 16),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfileChanges,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
