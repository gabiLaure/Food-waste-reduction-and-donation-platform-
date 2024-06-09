import 'package:flutter/material.dart';

class ImpactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of ImpactCards with different images, titles, and descriptions
    final List<ImpactCard> impactCards = [
      ImpactCard(
        imagePath: 'assets/malnutrition.jpeg',
        icon: Icons.local_dining,
        title: 'Nutrition and Health',
        description:
            'Regular food donations provide essential nutrients to growing children. Proper nutrition supports physical and cognitive development, helping orphans lead healthier lives.',
      ),
      ImpactCard(
        imagePath: 'assets/education.jpeg',
        icon: Icons.school,
        title: 'Education Support',
        description:
            'Donations help provide educational materials and resources, enabling children to attend school and pursue their dreams.',
      ),
      ImpactCard(
        imagePath: 'assets/emotion.jpeg',
        icon: Icons.medical_services,
        title: 'Medical Aid',
        description:
            'Medical supplies and healthcare services ensure that orphans receive the necessary medical attention and live healthy lives.',
      ),
      // Add more ImpactCards as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Impact Cards'),
      ),
      body: ListView(
        children: impactCards,
      ),
    );
  }
}

class ImpactCard extends StatelessWidget {
  final String imagePath;
  final IconData icon;
  final String title;
  final String description;

  ImpactCard({
    required this.imagePath,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Local image at the top
          Image.asset(
            imagePath,
            // width: double.infinity,
            // height: double.infinity,
            fit: BoxFit.cover,
          ),
          ListTile(
            leading: Icon(icon, size: 40),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
