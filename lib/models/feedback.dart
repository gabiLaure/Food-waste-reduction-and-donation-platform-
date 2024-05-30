import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBack {
  final String feedbackId;
  final String feedbackMessage;
  final String postedDate;

  FeedBack(
      {required this.feedbackId,
      required this.feedbackMessage,
      required this.postedDate,
      re});

  factory FeedBack.fromDocument(DocumentSnapshot doc) {
    return FeedBack(
      feedbackId: doc['feedbackId'],
      feedbackMessage: doc['feedbackMessage'],
      postedDate: doc['postedDate'],
    );
  }
}
