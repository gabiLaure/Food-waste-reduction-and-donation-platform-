import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String donationId;
  final String type;
  final String localComminity;
  final GeoPoint location;
  final List<String> donationImages;
  final String donationTitle;
  final String donationDescription;
  final String donationAvailability;
  final String donationStatus;
  final String expiryDate;
  final String donationDate;

  Donation({
    required this.donationId,
    required this.type,
    required this.localComminity,
    required this.location,
    required this.donationImages,
    required this.donationTitle,
    required this.donationDescription,
    required this.donationAvailability,
    required this.donationStatus,
    required this.expiryDate,
    required this.donationDate,
  });

  factory Donation.fromDocument(DocumentSnapshot doc) {
    return Donation(
      donationId: doc['donationId'],
      type: doc['type'],
      localComminity: doc['localComminity'],
      location: doc['location'],
      donationImages: doc['donationImages'],
      donationTitle: doc['donationTitle'],
      donationDescription: doc['donationDescription'],
      donationAvailability: doc['donationAvailability'],
      donationStatus: doc['donationStatus'],
      expiryDate: doc['expiryDate'],
      donationDate: doc['donationDate'],
    );
  }
}
