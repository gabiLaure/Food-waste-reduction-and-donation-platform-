import 'package:flutter/material.dart';
import '../models/donation.dart';
import '../models/user.dart';
import '../screens/add_donation.dart';
import '../widgets/donation_list.dart';
import '../widgets/user_list.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Donation> donations = [];
  List<User> users = [];

  void _addDonation(Donation donation) {
    setState(() {
      donations.add(donation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Administrateur'),
      ),
      body: Column(
        children: [
          Expanded(child: DonationList(donations: donations)),
          SizedBox(height: 20),
          UserList(users: users),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddDonation(onAddDonation: _addDonation)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
