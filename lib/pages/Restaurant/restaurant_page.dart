import 'package:flutter/material.dart';

class RestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RestaurantCard(restaurant: restaurant);
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
              child: Image.asset(
                restaurant.image,
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
            HeaderImage(image: restaurant.image),
            DescriptionSection(description: restaurant.description),
            OpeningHoursSection(openingHours: restaurant.openingHours),
            MenuSection(menuItems: restaurant.menuItems),
            ContactInformation(contactInfo: restaurant.contactInfo),
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
  final List<MenuItem> menuItems;

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
                color: Colors.deepPurple),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: menuItems.map((menuItem) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    height: 270,
                    width: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(menuItem.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  MenuItemCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 270,
        width: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fruits.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
            borderRadius: BorderRadius.circular(30)),
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
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

final List<Restaurant> restaurants = [
  Restaurant(
    name: 'Restaurant A',
    description: 'A delightful place to enjoy exquisite cuisine.',
    image: 'assets/restaurant/restaurantA.jpeg',
    openingHours: 'Mon-Fri: 10am - 10pm\nSat-Sun: 8am - 11pm',
    menuItems: [
      MenuItem(image: 'assets/restaurant/menu1.jpeg'),
      MenuItem(image: 'assets/restaurant/menu1.jpeg'),
      MenuItem(image: 'assets/restaurant/menu1.jpeg'),
    ],
    contactInfo: ContactInfo(
      address: '123 Main Street, Yaounde, Cameroun',
      phone: '+237 6789 456 789',
      email: 'contact@restaurantA.com',
    ),
  ),
  Restaurant(
    name: 'Restaurant B',
    description:
        'Welcome to Bistro Delights, a cozy corner where culinary passion meets a warm and inviting atmosphere.',
    image: 'assets/restaurant/restaurantB.jpeg',
    openingHours: 'Mon-Fri: 11am - 11pm\nSat-Sun: 9am - 12am',
    menuItems: [
      MenuItem(image: 'assets/restaurant/menu2.jpeg'),
      MenuItem(image: 'assets/restaurant/menu2.jpeg'),
      MenuItem(image: 'assets/restaurant/menu2.jpeg'),
    ],
    contactInfo: ContactInfo(
      address: '456 Another St, Yaounde, Cameroun',
      phone: '+237 6543 210 987',
      email: 'contact@restaurantB.com',
    ),
  ),
  Restaurant(
    name: 'Restaurant C',
    description:
        'Come enjoy the flavors and hospitality that make Bistro Delights a favorite spot for food lovers.',
    image: 'assets/restaurant/restaurantC.jpeg',
    openingHours: 'Mon-Fri: 11am - 11pm\nSat-Sun: 9am - 12am',
    menuItems: [
      MenuItem(image: 'assets/restaurant/menu3.jpeg'),
      MenuItem(image: 'assets/restaurant/menu3.jpeg'),
      MenuItem(image: 'assets/restaurant/menu3.jpeg'),
    ],
    contactInfo: ContactInfo(
      address: '456 Another St, Yaounde, Cameroun',
      phone: '+237 6543 210 987',
      email: 'contact@restaurantC.com',
    ),
  ),
];

class Restaurant {
  final String name;
  final String description;
  final String image;
  final String openingHours;
  final List<MenuItem> menuItems;
  final ContactInfo contactInfo;

  Restaurant({
    required this.name,
    required this.description,
    required this.image,
    required this.openingHours,
    required this.menuItems,
    required this.contactInfo,
  });
}

class MenuItem {
  final String image;

  MenuItem({required this.image});
}

class ContactInfo {
  final String address;
  final String phone;
  final String email;

  ContactInfo(
      {required this.address, required this.phone, required this.email});
}
