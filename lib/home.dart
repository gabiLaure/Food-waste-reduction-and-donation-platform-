//import 'package:caritas/pages/feeds_page.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'pages/all_donation.dart';
import 'pages/all_request_page.dart';
import 'pages/donation_page.dart';
import 'pages/feeds_page.dart';
import 'pages/impact_page.dart';
import 'pages/notification_page.dart';
import 'pages/orphanage_page.dart';
import 'pages/profile_page.dart';
import 'pages/schedule.dart';
import 'widgets/alert_dialogs.dart';

//import 'pages/feeds_page.dart';
// Import other necessary files if needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final screens = [
    // Replace these with your actual pages/screens

    FeedPage(),
    SchedulePage(),
    DonationPage(),
    ImpactPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caritas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        leading: Image.asset(
          'assets/caritas_logo.png', // Replace with your image asset path
          width: 32, // Set the desired width
          height: 32, // Set the desired height
        ),
        actions: [
          Builder(builder: (context) {
            // Add other action buttons here if needed
            return Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_active_outlined),
                  onPressed: () {
                    // Handle notification button click here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ],
            );
          })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple[200],
              ),
              child: Center(
                child: Text(
                  'My Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.family_restroom),
              title: Text('Orphanage'),
              onTap: () {
                // Handle navigation or other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrphanageApp(), // Replace with your actual notification page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text('Donation'),
              onTap: () {
                // Handle navigation or other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllDonations(), // Replace with your actual notification page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake),
              title: Text('Request'),
              onTap: () {
                // Handle navigation or other actions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllRequest(), // Replace with your actual notification page
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.fastfood_outlined),
            //   title: Text('Food Tips'),
            //   onTap: () {
            //     // Handle navigation or other actions
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => FoodDetailsPage(
            //           image: 'image',
            //           foodName: 'foodName',
            //           foodDescription: 'foodDescription',
            //           foodTip: 'foodTip',
            //         ), // Replace with your actual notification page
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle navigation or other actions
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                SignOutAlertDialog().showAlert(context);
              },
            ),
            // logout button

            // Add more list items as needed
          ],
        ),
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // backgroundColor: Colors.blue,
          //iconTheme: IconThemeData(color: Colors.white),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              // Style for selected label
              return TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Customize the color
              );
            } else {
              // Style for unselected label
              return TextStyle(
                fontSize: 14,
                color:
                    Color.fromARGB(216, 104, 102, 102), // Customize the color
              );
            }
          }),
        ),
        child: NavigationBar(
          backgroundColor: Colors.purple[200],
          indicatorColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: index == 0 ? Colors.white : null,
                ),
                label: 'Home'),
            NavigationDestination(
              icon: Icon(
                Icons.schedule,
                color: index == 1 ? Colors.white : null,
              ),
              label: 'Schedule',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.volunteer_activism,
                color: index == 2 ? Colors.white : null,
              ),
              label: 'Donate',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.satellite_alt_outlined,
                color: index == 3 ? Colors.white : null,
              ),
              label: 'Impact',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_pin,
                color: index == 4 ? Colors.white : null,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
