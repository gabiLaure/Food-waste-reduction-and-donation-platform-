import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'view_donation.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text('My Schedule',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25)))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Calendar widget
              TableCalendar(
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: DateTime.now(),
                // Customize other properties as needed
              ),
              SizedBox(height: 16), // Add spacing
              // List of scheduled programs (cards)
              SingleChildScrollView(
                child: Column(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.fastfood_outlined),
                              title: Text(
                                'Thanks for Sharing!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.shopping_bag_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('7 kg'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.location_on),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text('100km'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.watch_later_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Collection (evening)'),
                                    ],
                                  ),

                                  // Add more lines as needed
                                ],
                              ),
                            ),
                            // Second row with elevated buttons
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle button 2 press
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DonationsFragment()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adjust corner radius
                                  ),
                                ),
                                child: Text('View Donation'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
