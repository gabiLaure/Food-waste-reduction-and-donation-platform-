import 'package:flutter/material.dart';

class ImpactPage extends StatelessWidget {
  const ImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Donation Impact on Orphans'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImpactCard(
                icon: Icons.local_dining,
                title: 'Nutrition and Health',
                description:
                    'Regular food donations provide essential nutrients to growing children. Proper nutrition supports physical and cognitive development, helping orphans lead healthier lives.',
              ),
              ImpactCard(
                icon: Icons.accessibility_new,
                title: 'Reducing Malnutrition',
                description:
                    'Orphans are particularly vulnerable to malnutrition and food insecurity. Donations help prevent malnutrition-related illnesses and stunted growth.',
              ),
              ImpactCard(
                icon: Icons.favorite,
                title: 'Emotional Well-Being',
                description:
                    'Consistent meals contribute to emotional stability and overall well-being. Feeling cared for through food donations positively impacts an orphan\'s mental health.',
              ),
              ImpactCard(
                icon: Icons.school,
                title: 'Education and Future Opportunities',
                description:
                    'Well-fed orphans can focus better in school, improving their educational outcomes. A healthy start increases their chances of breaking the cycle of poverty.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImpactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  ImpactCard(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
