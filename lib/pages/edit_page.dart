import 'package:flutter/material.dart';

class EditDonorProfilePage extends StatefulWidget {
  @override
  _EditDonorProfilePageState createState() => _EditDonorProfilePageState();
}

class _EditDonorProfilePageState extends State<EditDonorProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Donor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: interestsController,
              decoration: InputDecoration(labelText: 'Interests'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save changes logic (update donor data)
                final updatedFullName = fullNameController.text;
                final updatedEmail = emailController.text;
                final updatedAddress = addressController.text;
                final updatedInterests = interestsController.text;

                // Implement your logic to save changes to the donor profile
                // (e.g., update database, API call, etc.)

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}