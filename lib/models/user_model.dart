import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelClass {
  final String uuid;
  final String accountType;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  // final String homeAddress;
  final String accountCreated;
  final String profileImage;

  UserModelClass({
    required this.uuid,
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    // required this.homeAddress,
    required this.accountCreated,
    required this.profileImage,
  });

  factory UserModelClass.fromDocument(DocumentSnapshot doc) {
    return UserModelClass(
      uuid: doc['uuid'],
      accountType: doc['accountType'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      email: doc['email'],
      contactNumber: doc['contactNumber'],
      // homeAddress: doc['homeAddress'],
      accountCreated: doc['accountCreated'],
      profileImage: doc['profileImage'],
    );
  }
}
