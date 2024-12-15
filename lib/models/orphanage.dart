import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  // Méthode pour convertir un document Firestore en Orphanage
  factory Orphanage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Orphanage(
      id: doc.id,
      name: data['orphanageName'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['image'] ?? '',
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

  // New factory method that constructs from a Map object
  factory Orphanage.fromObject(Map<String, dynamic> object) {
    return Orphanage(
      id: object['id'] ?? '',
      name: object['name'] ?? '',
      address: object['address'] ?? '',
      latitude: object['latitude'] ?? 0.0,
      longitude: object['longitude'] ?? 0.0,
      description: object['description'] ?? '',
      imageUrl: object['imageUrl'] ?? '',
      phone: object['phone'] ?? '',
      healthcare: object['healthcare'] ?? '',
      education: object['education'] ?? '',
      email: object['email'] ?? '',
    );
  }
}
