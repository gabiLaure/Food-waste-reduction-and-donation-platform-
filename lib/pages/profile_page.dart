import 'package:caritas/pages/edit_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/pp.jpeg', // Replace with donor's profile image URL
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Laure Ngopnang', // Replace with donor's name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'laure.ngopnang@gmail.com', // Replace with donor's email
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle edit profile button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditDonorProfilePage()),
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
        ),
      ),
    );
  }
}
