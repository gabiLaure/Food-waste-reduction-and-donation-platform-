import 'package:flutter/material.dart';
import '../models/donation.dart';

class DonationList extends StatelessWidget {
  final List<Donation> donations;

  DonationList({required this.donations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(donations[index].donorName),
          subtitle: Text(
              '${donations[index].foodType} - ${donations[index].recipient} on ${donations[index].date}'),
        );
      },
    );
  }
}
