import 'package:caritas/pages/request_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'listing_creation_page.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text('Town'),
                    SizedBox(
                      width: 10,
                    ),
                    Text('20 km'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Request'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo (Replace with your logo widget)
                _buildUI(),
                //CircularProgressIndicator(), // Example of a loading animation
                SizedBox(height: 20),
                Text(
                  'There are no ads in this area',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text('Expand my search area'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _buildUI() {
  return Center(
    child: LottieBuilder.asset("assets/animation/delivery.json"),
  );
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('Make a choice')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the listing creation page for donation
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListingCreationPage()),
                );
              },
              child: Center(child: Text('Make a Donation')),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the listing creation page for request
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestDonation()),
                );
              },
              child: Center(child: Text('Make a Request')),
            ),
          ],
        ),
      );
    },
  );
}
