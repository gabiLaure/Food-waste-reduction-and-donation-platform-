import 'package:caritas/models/orphanage.dart';
import 'package:caritas/pages/Donation/listing_creation_page.dart';
import 'package:flutter/material.dart'; // Assuming ListingCreationPage exists.

class OrphanageDetailPage extends StatelessWidget {
  final Orphanage orphanage;

  OrphanageDetailPage({required this.orphanage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orphanage.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderImage(image: orphanage.imageUrl),
            MissionStatement(mission: orphanage.description),
            ServicesSection(
              healthcare: orphanage.healthcare,
              education: orphanage.education,
            ),
            ContactInformation(
                address: orphanage.address,
                phone: orphanage.phone,
                email: orphanage.email),
            _buildFloatingActionButton(context),
          ],
        ),
      ),
    );
  }
}

class HeaderImage extends StatelessWidget {
  final String image;

  HeaderImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Welcome to Our Orphanage',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class MissionStatement extends StatelessWidget {
  final String mission;

  MissionStatement({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.teal[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            mission,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  final String healthcare;
  final String education;

  ServicesSection({required this.healthcare, required this.education});

  @override
  Widget build(BuildContext context) {
    final List<Service> services = [
      Service(
        title: 'Healthcare',
        description: healthcare,
        icon: Icons.health_and_safety,
      ),
      Service(
        title: 'Education',
        description: education,
        icon: Icons.school,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 10),
          ...services.map((service) => ServiceItem(service: service)),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final Service service;

  ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(service.icon, color: Colors.teal, size: 40),
        title: Text(
          service.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          service.description,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class ContactInformation extends StatelessWidget {
  final String address;
  final String phone;
  final String email;

  ContactInformation(
      {required this.address, required this.phone, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 10),
          ContactItem(icon: Icons.location_on, text: address),
          ContactItem(icon: Icons.phone, text: phone),
          ContactItem(icon: Icons.email, text: email),
        ],
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Widget _buildFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: Colors.teal[50],
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListingCreationPage(),
        ),
      )
    },
    child: Icon(Icons.volunteer_activism),
  );
}

class Service {
  final String title;
  final String description;
  final IconData icon;

  Service({required this.title, required this.description, required this.icon});
}
