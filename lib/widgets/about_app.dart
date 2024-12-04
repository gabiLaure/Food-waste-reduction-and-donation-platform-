import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to Caritas \'Food Donation App\'',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Our app connects donors with local Individuals, orphanages, restaurants, and supermarkets to ensure that excess food is distributed to those in need. Using advanced geospatial matching technology, we help locate nearby donation points and facilitate seamless transactions between donors and recipients.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'App Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Geospatial matching of donations to nearby recipients.\n'
              '- Real-time notifications for donation requests.\n'
              '- Secure and easy-to-use interface for donors and recipients.\n'
              '- User privacy control settings for location and contact information.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'Mission Statement:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our mission is to reduce food waste and hunger by connecting those with excess food to organizations in need. We believe in building a sustainable community where everyone has access to the food they need.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'For more information, feedback, or inquiries, reach us at:\n'
              'Email: support@caritas.com\n'
              'Phone: (237) 696-667-503\n'
              'Website: www.caritas.com',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'Version: 1.0.0',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent),
            ),
          ],
        ),
      ),
    );
  }
}
