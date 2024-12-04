import 'dart:io';

import 'package:caritas/models/user_model.dart';
import 'package:caritas/pages/Donation/edit_page.dart';
import 'package:caritas/widgets/about_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/alert_dialogs.dart';
import '../../widgets/notification_preferences.dart';
import '../../widgets/privacy_setting.dart';
import '../Orphanage/edit_orphanage_registration.dart';
import '../Restaurant/restaurant_edit.dart';
import '../Supermarket/edit_supermarket.dart';
import 'edit_profil_page.dart';

String orphanageId = 'id';
String accountTypeName = '';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('userUid', isEqualTo: currentUserID)
              .snapshots(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No user data found.'));
            } else {
              UserModelClass userModelClass =
                  UserModelClass.fromDocument(dataSnapshot.data!.docs[0]);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'User Profile',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                              as ImageProvider<Object> // Ensure correct type
                          : NetworkImage(
                                  'https://example.com/default_profile_image.jpg')
                              as ImageProvider<Object>,
                      child:
                          _image == null ? Icon(Icons.person, size: 50) : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                        // if (_image != null) {
                        //   await _updateUserProfil(); // Upload image after picking
                        // }
                      },
                      child: Text('Pick Profile Image'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${userModelClass.fullname}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userModelClass.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    SizedBox(height: 20),
                    // Settings Section
                    Column(
                      children: [
                        _buildSettingsTile(
                          'Edit Profile',
                          Icons.person,
                          () {
                            // Navigate to Edit profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(),
                              ),
                            );
                          },
                        ),
                        // Retrieve orphanageId dynamically
                        _buildSettingsTile(
                          'Edit Orphanage',
                          Icons.house,
                          () {
                            // Navigate to Edit orphanage registration, passing the orphanageId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrphanageEdit(
                                    orphanageId:
                                        orphanageId), // Pass orphanageId
                              ),
                            );
                          },
                        ),
                        Column(
                          children: [
                            if (accountTypeName == 'orphanage')
                              _buildSettingsTile(
                                'Edit Orphanage',
                                Icons.house,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrphanageEdit(
                                          orphanageId: orphanageId),
                                    ),
                                  );
                                },
                              )
                            else if (accountTypeName == 'restaurant')
                              _buildSettingsTile(
                                'Edit Restaurant',
                                Icons.restaurant,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RestaurantEdit(),
                                    ),
                                  );
                                },
                              )
                            else if (accountTypeName == 'supermarket')
                              _buildSettingsTile(
                                'Edit Supermarket',
                                Icons.shopping_cart,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditSupermarket(),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        _buildSettingsTile(
                          'Notification Preferences',
                          Icons.notifications,
                          () {
                            // Navigate to notification preferences
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NotificationPreferencesPage(),
                              ),
                            );
                          },
                        ),
                        _buildSettingsTile('Privacy Settings', Icons.lock, () {
                          // Navigate to privacy settings
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacySettingsPage(),
                            ),
                          );
                        }),
                        _buildSettingsTile('About App', Icons.info, () {
                          // Show app information
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutAppPage(),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            SignOutAlertDialog().showAlert(context);
                          },
                          child: const Text('Logout',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              )),
                        )),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Handle actual logout logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// class UserModelClass {
//   String fullname;
//   String email;
//   String? profileImageUrl;

//   UserModelClass.fromDocument(DocumentSnapshot doc)
//       : fullname = doc['fullname'],
//         email = doc['email'],
//         profileImageUrl = doc['profileImageUrl'];
// }
