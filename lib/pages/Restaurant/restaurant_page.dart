import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('restaurants').snapshots(),
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
            return Center(child: Text('No restaurant found.'));
          }

          // Convertir les documents en objets Orphanage
          final restaurants = snapshot.data!.docs
              .map((doc) => Restaurant.fromFirestore(doc))
              .toList();

          print(restaurants);
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantCard({required this.restaurant});

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
                  RestaurantDetailPage(restaurant: restaurant),
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
                restaurant.imageUrl,
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
                    restaurant.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    restaurant.description,
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

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantDetailPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderImage(image: restaurant.imageUrl),
            DescriptionSection(description: restaurant.description),
            OpeningHoursSection(openingHours: restaurant.openingHours),
            MenuSection(menuItems: restaurant.menuImages),
            ContactInformation(
                address: restaurant.address,
                phone: restaurant.phone,
                email: restaurant.email),
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
            'Welcome to Our Restaurant',
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

class MenuSection extends StatelessWidget {
  final List<dynamic> menuItems;

  MenuSection({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: menuItems.map((menuItem) {
                return MenuItemCard(menuItem: menuItem);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String menuItem;

  MenuItemCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 270,
        width: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(menuItem), // Utilisation de l'image du MenuItem
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 149, 145, 145).withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        // child: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(
        //       menuItem.name, // Nom du plat ou élément du menu
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
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

class Restaurant {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final String phone;
  final List<dynamic> menuImages; // Liste d'images du menu
  final String openingHours; // Liste des heures d'ouverture
  final String email;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.imageUrl,
    required this.phone,
    required this.menuImages,
    required this.openingHours,
    required this.email,
  });

// Méthode pour convertir un document Firestore en Orphanage
  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: data['restaurantName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['image'] ?? '',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      menuImages: data['menuImages'] ?? '',
      openingHours: data['openingHours'] ?? '',
      // contactInfo: data['contactInfo'] ?? '',
    );
  }
}
