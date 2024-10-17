import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Dashboard Overview Cards
            Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildStatCard('Total Donations', '1200', Colors.blue,
                    Icons.volunteer_activism),
                _buildStatCard('Active Donations', '45', Colors.orange,
                    Icons.local_shipping),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildStatCard('Total Request', '300', Colors.purple,
                    Icons.mobile_screen_share),
                _buildStatCard('Completed Donations', '1150', Colors.green,
                    Icons.local_shipping),
              ],
            ),

            // Recent Activity Feed
            SizedBox(height: 32),
            Text(
              'Recent Activities',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildActivityCard('SuperMart donated fresh vegetables', 'Today'),
            _buildActivityCard('GreenEat donated 50 bread loaves', 'Yesterday'),

            // Top Donors
            SizedBox(height: 32),
            Text(
              'Top Donors',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildDonorTile('SuperMart', '30 donations this month'),
            _buildDonorTile('GreenEat', '25 donations this month'),

            // Geospatial Map Placeholder
            SizedBox(height: 32),
            Text(
              'Geospatial Donation Map',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 200,
              color: Colors.grey[300], // Map placeholder
              child: Center(child: Text('Map here')),
            ),

            // Pending Approvals
            SizedBox(height: 32),
            Text(
              'Pending Approvals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildActivityCard(
                'John Doe requested approval for a donation', 'Pending'),
          ],
        ),
      ),
    ));
  }

  // Stat Card Widget
  Widget _buildStatCard(
      String title, String count, Color color, IconData icon) {
    return Card(
      elevation: 4,
      child: Container(
        width: 180,
        height: 150,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 30, color: color), // Add an icon here
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              count,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Activity Card Widget
Widget _buildActivityCard(String activity, String time) {
  return Card(
    child: ListTile(
      leading: Icon(Icons.food_bank_rounded, color: Colors.green),
      title: Text(activity),
      subtitle: Text(time),
    ),
  );
}

// Top Donor Tile Widget
Widget _buildDonorTile(String donor, String stats) {
  return ListTile(
    leading: Icon(Icons.star_border_outlined, color: Colors.blue),
    title: Text(donor),
    subtitle: Text(stats),
  );
}
