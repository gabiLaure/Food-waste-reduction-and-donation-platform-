import 'package:caritas/admin/widgets/admin_home.dart';
import 'package:caritas/home.dart';
import 'package:caritas/pages/Donation/all_donation.dart';
import 'package:caritas/pages/Home/all_request_page.dart';
import 'package:caritas/pages/Home/feeds_page.dart';
import 'package:caritas/pages/Home/notification_page.dart';
import 'package:caritas/widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';

import '../pages/Grocery/grocery_page.dart';
import '../pages/Orphanage/orphanage_page.dart';
import '../pages/Restaurant/restaurant_page.dart';
import 'widgets/admin_settings.dart';
import 'widgets/donation_management.dart';
import 'widgets/grocery_management.dart';
import 'widgets/orphanage_management.dart';
import 'widgets/reports.dart';
import 'widgets/request_management.dart';
import 'widgets/restaurant_management.dart';
import 'widgets/user_management.dart';

//import 'pages/feeds_page.dart';
// Import other necessary files if needed

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int index = 0;

  final screens = [
    // Replace these with your actual pages/screens

    AdminHomePage(),
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
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
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
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.family_restroom),
              title: Text('Orphanage Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrphanageManagementPage(), // Link to Orphanage management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Restaurant Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantManagementPage(), // Link to Restaurant management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_grocery_store_outlined),
              title: Text('Grocery Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GroceryManagementPage(), // Link to Grocery management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text('Donation Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DonationManagementPage(), // Link to Donation management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake),
              title: Text('Request Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RequestManagementPage(), // Link to Request management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Reports'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportsPage(), // Link to Reports page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('User Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserManagementPage(), // Link to User management page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(), // Link to Settings page
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                SignOutAlertDialog()
                    .showAlert(context); // Show a logout confirmation dialog
              },
            ),
          ],
        ),
      ),
      body: screens[index],
    );
  }
}
