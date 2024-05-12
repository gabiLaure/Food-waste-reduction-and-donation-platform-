//import 'package:caritas/pages/feeds_page.dart';
import 'package:caritas/pages/donation_page.dart';
import 'package:caritas/pages/profile_page.dart';
import 'package:caritas/pages/feeds_page.dart';
import 'package:flutter/material.dart';

import 'pages/impact_page.dart';
import 'pages/schedule.dart';

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
      appBar:  AppBar(
        title: const Text('Dashboard'),
        leading: Image.asset(
          'assets/caritas_logo.png', // Replace with your image asset path
          width: 32, // Set the desired width
          height: 32, // Set the desired height
        ),
        actions: [
          // Add other action buttons here if needed
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button click here
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              // Handle search button click here
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_applications_outlined),
            onPressed: () {
              // Handle search button click here
            },
          ),
        ],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.blue, 
          indicatorColor: Colors.grey[100]
          ),
        child: NavigationBar(
          backgroundColor: Colors.purple[200],
          selectedIndex: index,
          onDestinationSelected: (index) => 
          setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home), 
              label: 'Home'
              ),
              NavigationDestination(
              icon: Icon(Icons.schedule),
              label: 'Schedule',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism),
              label: 'Donate',
            ),
            NavigationDestination(
              icon: Icon(Icons.satellite_alt_outlined),
              label: 'Impact',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_pin),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}