import 'package:caritas/models/user_model.dart';
import 'package:caritas/pages/Donation/edit_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('uuid', isEqualTo: currentUserID)
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
                      backgroundImage: Image.network(
                        userModelClass.profileImage ?? '',
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person, size: 50),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ).image,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${userModelClass.firstName} ${userModelClass.lastName}',
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
                                builder: (context) => EditDonorProfilePage(),
                              ),
                            );
                          },
                        ),
                        _buildSettingsTile(
                          'Notification Preferences',
                          Icons.notifications,
                          () {
                            // Navigate to notification preferences
                          },
                        ),
                        _buildSettingsTile('Privacy Settings', Icons.lock, () {
                          // Navigate to privacy settings
                        }),
                        _buildSettingsTile('About App', Icons.info, () {
                          // Show app information
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
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
