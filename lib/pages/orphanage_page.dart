import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrphanageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.tealAccent,
        textTheme: GoogleFonts.crimsonProTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: OrphanageListPage(),
    );
  }
}

class OrphanageListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanages'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: orphanages.length,
        itemBuilder: (context, index) {
          final orphanage = orphanages[index];
          return OrphanageCard(orphanage: orphanage);
        },
      ),
    );
  }
}

class OrphanageCard extends StatelessWidget {
  final Orphanage orphanage;

  OrphanageCard({required this.orphanage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrphanageDetailPage(orphanage: orphanage),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                orphanage.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orphanage.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    orphanage.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrphanageDetailPage extends StatelessWidget {
  final Orphanage orphanage;

  OrphanageDetailPage({required this.orphanage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orphanage.name),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderImage(image: orphanage.image),
            MissionStatement(mission: orphanage.mission),
            ServicesSection(services: orphanage.services),
            ContactInformation(contactInfo: orphanage.contactInfo),
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
          image: AssetImage(image),
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
  final List<Service> services;

  ServicesSection({required this.services});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          SizedBox(height: 10),
          ...services.map((service) => ServiceItem(service: service)).toList(),
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
  final ContactInfo contactInfo;

  ContactInformation({required this.contactInfo});

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
          ContactItem(
            icon: Icons.location_on,
            text: contactInfo.address,
          ),
          ContactItem(
            icon: Icons.phone,
            text: contactInfo.phone,
          ),
          ContactItem(
            icon: Icons.email,
            text: contactInfo.email,
          ),
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

final List<Orphanage> orphanages = [
  Orphanage(
    name: 'Orphanage A',
    description: 'A loving home for children in need.',
    image: 'assets/images/orphanage1.jpeg',
    mission:
        'Our mission is to provide a loving and nurturing environment for all children.',
    services: [
      Service(
        title: 'Education',
        description:
            'High-quality education to help children achieve their full potential.',
        icon: Icons.school,
      ),
      Service(
        title: 'Healthcare',
        description: 'Healthcare services to ensure all children are healthy.',
        icon: Icons.health_and_safety,
      ),
    ],
    contactInfo: ContactInfo(
      address: '123 Orphanage Street, City, Country',
      phone: '+123 456 789',
      email: 'contact@orphanagea.org',
    ),
  ),
  Orphanage(
    name: 'Orphanage B',
    description: 'A loving home for children in need.',
    image: 'assets/images/orphanage2.jpeg',
    mission:
        'Our mission is to provide a loving and nurturing environment for all children.',
    services: [
      Service(
        title: 'Education',
        description:
            'High-quality education to help children achieve their full potential.',
        icon: Icons.school,
      ),
      Service(
        title: 'Healthcare',
        description: 'Healthcare services to ensure all children are healthy.',
        icon: Icons.health_and_safety,
      ),
    ],
    contactInfo: ContactInfo(
      address: '123 Orphanage Street, City, Country',
      phone: '+123 456 789',
      email: 'contact@orphanagea.org',
    ),
  ),
  Orphanage(
    name: 'Orphanage C',
    description: 'A loving home for children in need.',
    image: 'assets/images/orphanage3.jpeg',
    mission:
        'Our mission is to provide a loving and nurturing environment for all children.',
    services: [
      Service(
        title: 'Education',
        description:
            'High-quality education to help children achieve their full potential.',
        icon: Icons.school,
      ),
      Service(
        title: 'Healthcare',
        description: 'Healthcare services to ensure all children are healthy.',
        icon: Icons.health_and_safety,
      ),
    ],
    contactInfo: ContactInfo(
      address: '123 Orphanage Street, City, Country',
      phone: '+123 456 789',
      email: 'contact@orphanagea.org',
    ),
  ),
  // Add more orphanages here
];

class Orphanage {
  final String name;
  final String description;
  final String image;
  final String mission;
  final List<Service> services;
  final ContactInfo contactInfo;

  Orphanage({
    required this.name,
    required this.description,
    required this.image,
    required this.mission,
    required this.services,
    required this.contactInfo,
  });
}

class Service {
  final String title;
  final String description;
  final IconData icon;

  Service({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class ContactInfo {
  final String address;
  final String phone;
  final String email;

  ContactInfo({
    required this.address,
    required this.phone,
    required this.email,
  });
}
