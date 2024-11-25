import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelClass {
  final String userUid;
  final String accountType;
  final String fullname;
  final String email;
  final String phone;
  // final String homeAddress;
  String accountCreated = '';
  String profileImage = '';

  UserModelClass({
    required this.userUid,
    required this.accountType,
    required this.fullname,
    required this.email,
    required this.phone,
  });

  factory UserModelClass.fromDocument(DocumentSnapshot doc) {
    return UserModelClass(
      userUid: doc['userUid'],
      accountType: doc['accountType'],
      fullname: doc['fullname'],
      email: doc['email'],
      phone: doc['phone'],
    );
  }
  // model to document
  Map<String, dynamic> toDocument() {
    return {
      "userUid": userUid,
      "accountType": accountType,
      "fullname": fullname,
      "email": email,
      "phone": phone,
      "accountCreated": accountCreated,
      "profileImage": profileImage
    };
  }
}
