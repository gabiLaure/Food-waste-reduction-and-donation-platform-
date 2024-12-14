import 'package:cloud_firestore/cloud_firestore.dart';

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
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      openingHours: data['openingHours'] ?? '',
      // contactInfo: data['contactInfo'] ?? '',
    );
  }

  factory Supermarket.fromObject(Map<String, dynamic> data) {
    return Supermarket(
      id: data['id'] ?? '',
      name: data['supermarketName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['image'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      description: data['description'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      openingHours: data['openingHours'] ?? '',
    );
  }
}
