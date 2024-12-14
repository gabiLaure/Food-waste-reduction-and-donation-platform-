import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Restaurant.fromObject(Map<String, dynamic> data) {
    return Restaurant(
      id: data['id'] ?? '',
      name: data['restaurantName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['image'] ?? '',
      latitude: data['latitude'] is double
          ? data['latitude']
          : double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0,
      longitude: data['longitude'] is double
          ? data['longitude']
          : double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0,
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      menuImages: data['menuImages'] is List ? data['menuImages'] : [],
      openingHours: data['openingHours'] ?? '',
    );
  }
}
