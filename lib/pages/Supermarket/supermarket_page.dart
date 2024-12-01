import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupermarketListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermarkets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('supermarket').snapshots(),
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
            return Center(child: Text('No Supermarket found.'));
          }

          // Convertir les documents en objets Orphanage
          final supermarkets = snapshot.data!.docs
              .map((doc) => Supermarket.fromFirestore(doc))
              .toList();

          print(supermarkets);
          return ListView.builder(
            itemCount: supermarkets.length,
            itemBuilder: (context, index) {
              final supermarket = supermarkets[index];
              return SupermarketCard(supermarket: supermarket);
            },
          );
        },
      ),
    );
  }
}

class SupermarketCard extends StatelessWidget {
  final Supermarket supermarket;

  SupermarketCard({required this.supermarket});

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
              builder: (context) =>
                  SupermarketDetailPage(supermarket: supermarket),
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
                supermarket.imageUrl,
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
                    supermarket.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    supermarket.description,
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

class SupermarketDetailPage extends StatelessWidget {
  final Supermarket supermarket;

  SupermarketDetailPage({required this.supermarket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supermarket.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderImage(image: supermarket.imageUrl),
            DescriptionSection(description: supermarket.description),
            OpeningHoursSection(openingHours: supermarket.openingHours),
            ContactInformation(
                address: supermarket.address,
                phone: supermarket.phone,
                email: supermarket.email),
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
            'Welcome to Our Supermarket',
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

class DescriptionSection extends StatelessWidget {
  final String description;

  DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.deepPurple[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class OpeningHoursSection extends StatelessWidget {
  final String openingHours;

  OpeningHoursSection({required this.openingHours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Opening Hours',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          SizedBox(height: 10),
          Text(
            openingHours,
            style: TextStyle(fontSize: 16),
          ),
        ],
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
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
          Icon(icon, color: Colors.deepPurple),
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

class Supermarket {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final String phone;
  final String openingHours; // Liste des heures d'ouverture
  final String email;

  Supermarket({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.imageUrl,
    required this.phone,
    required this.openingHours,
    required this.email,
  });

// Méthode pour convertir un document Firestore en Orphanage
  factory Supermarket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Supermarket(
      id: doc.id,
      name: data['supermarketName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['image'] ?? '',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      openingHours: data['openingHours'] ?? '',
      // contactInfo: data['contactInfo'] ?? '',
    );
  }
}
