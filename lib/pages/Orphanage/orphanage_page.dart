import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrphanageListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanages'),
        // backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orphanages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant le fetching
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Affiche un message d'erreur si la récupération échoue
            return Center(child: Text('An error occurred!'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Affiche un message si aucun orphelinat n'est trouvé
            return Center(child: Text('No orphanages found.'));
          }

          // Convertir les documents en objets Orphanage
          final orphanages = snapshot.data!.docs
              .map((doc) => Orphanage.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: orphanages.length,
            itemBuilder: (context, index) {
              final orphanage = orphanages[index];
              return OrphanageCard(orphanage: orphanage);
            },
          );
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
              child: Image.network(
                orphanage.imageUrl,
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
        // backgroundColor: Colors.teal,
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
          image:
              NetworkImage(image), // Utilisation de NetworkImage pour le lien
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
          ContactItem(
            icon: Icons.location_on,
            text: address,
          ),
          ContactItem(
            icon: Icons.phone,
            text: phone,
          ),
          ContactItem(
            icon: Icons.email,
            text: email,
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

class Orphanage {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final String phone;
  final String healthcare;
  final String education;
  final String email;
  // final String mission;
  // final List<String> services;
  // final ContactInfo contactInfo;

  Orphanage({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.imageUrl,
    required this.phone,
    required this.healthcare,
    required this.education,
    required this.email,
    // required this.mission,
    // required this.services,
    // required this.contactInfo,
  });

  // Méthode pour convertir un document Firestore en Orphanage
  factory Orphanage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Orphanage(
      id: doc.id,
      name: data['orphanageName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      healthcare: data['healthcare'] ?? '',
      education: data['education'] ?? '',
      // contactInfo: data['contactInfo'] ?? '',
    );
  }
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
