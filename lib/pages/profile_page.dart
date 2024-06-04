// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'edit_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text('Donor Profile'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where('uuid', isEqualTo: currentUserID.toString())
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    UserModelClass userModelClass =
                        UserModelClass.fromDocument(dataSnapshot.data!.docs[0]);

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: Image.network(
                              userModelClass.profileImage,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ).image,
                            // NetworkImage(userModelClass.profileImage),
                            // backgroundImage: AssetImage(
                            //   'assets/pp.jpeg', // Replace with donor's profile image URL
                            // ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${userModelClass.firstName} ${userModelClass.lastName}', // Replace with donor's name
                            // 'Laure Ngopnang', // Replace with donor's name
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userModelClass.email, // Replace with donor's email
                            // 'laure.ngopnang@gmail.com', // Replace with donor's email
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // Handle edit profile button press
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditDonorProfilePage()),
                              );
                            },
                            child: Text('Edit Profile'),
                          ),
                          SizedBox(height: 24),
                          // Donation History Section
                          ListTile(
                            leading: Icon(Icons.history),
                            title: Text('Donation History'),
                            subtitle: Text('Total donations: \$5000'),
                          ),
                          Divider(), // Add a horizontal line
                          // Interests Section
                          ListTile(
                            leading: Icon(Icons.favorite),
                            title: Text('Interests'),
                            subtitle: Text('Environment, Nutrition'),
                          ),
                          Divider(),
                          // Communication Preferences Section
                          ListTile(
                            leading: Icon(Icons.mail),
                            title: Text('Communication Preferences'),
                            subtitle: Text('Email preferred'),
                          ),
                        ],
                      ),
                    );
                  }
                })));
  }
}
