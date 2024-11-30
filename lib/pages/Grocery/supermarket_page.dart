import 'package:flutter/material.dart';

class GroceryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermarkets'),
        // backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: Supermarkets.length,
        itemBuilder: (context, index) {
          final supermarket = Supermarkets[index];
          return GroceryCard(supermarket: supermarket);
        },
      ),
    );
  }
}

class GroceryCard extends StatelessWidget {
  final Grocery supermarket;

  GroceryCard({required this.supermarket});

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
              builder: (context) => GroceryDetailPage(supermarket: supermarket),
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
                supermarket.image,
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

class GroceryDetailPage extends StatelessWidget {
  final Grocery supermarket;

  GroceryDetailPage({required this.supermarket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supermarket.name),
        // backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderImage(image: supermarket.image),
            DescriptionSection(description: supermarket.description),
            OpeningHoursSection(openingHours: supermarket.openingHours),
            ContactInformation(contactInfo: supermarket.contactInfo),
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
            'Welcome to Our Grocery',
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

final List<Grocery> Supermarkets = [
  Grocery(
    name: 'Supermarket A',
    description: 'A delightful place to enjoy exquisite cuisine.',
    openingHours: 'Mon-Fri: 10am - 10pm\nSat-Sun: 8am - 11pm',
    image: 'assets/supermarket/supermarket1.jpeg',
    contactInfo: ContactInfo(
      address: 'Biyem-Assi Street, Yaounde, Cameroun',
      phone: '+237 6789 456 789',
      email: 'contact@Grocerya.org',
    ),
  ),
  Grocery(
    name: 'Supermarket B',
    description: 'A loving home for children in need.',
    image: 'assets/supermarket/supermarket2.jpeg',
    openingHours: 'Mon-Fri: 10am - 10pm\nSat-Sun: 8am - 11pm',
    contactInfo: ContactInfo(
      address: 'TPO Street, Bafoussam, Cameroun',
      phone: '+237 6789 456 789',
      email: 'contact@Grocerya.org',
    ),
  ),
  Grocery(
    name: 'Supermarket C',
    description: 'A loving home for children in need.',
    image: 'assets/supermarket/supermarket3.jpeg',
    openingHours: 'Mon-Fri: 10am - 10pm\nSat-Sun: 8am - 11pm',
    contactInfo: ContactInfo(
      address: 'Chapelle Nsimeyong, Yaounde, Cameroun',
      phone: '+237 6789 456 789',
      email: 'contact@Grocerya.org',
    ),
  ),
  // Add more Supermarkets here
];

class Grocery {
  final String name;
  final String description;
  final String openingHours;
  final String image;
  final ContactInfo contactInfo;

  Grocery({
    required this.name,
    required this.description,
    required this.openingHours,
    required this.image,
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
