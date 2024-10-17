import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports & Insights'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildReportCard(
            'Total Donations Completed',
            '1200',
            Colors.blue,
            Icons.volunteer_activism,
          ),
          _buildReportCard(
            'Top Donors (Restaurants)',
            'Restaurant A - 25 Donations',
            Colors.orange,
            Icons.restaurant,
          ),
          _buildReportCard(
            'Geographical Distribution (Top Region)',
            'Douala - 450 Donations',
            Colors.green,
            Icons.location_on,
          ),
          _buildReportCard(
            'Active Requests vs Fulfilled Requests',
            'Active: 60 | Fulfilled: 540',
            Colors.purple,
            Icons.request_page,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle report export action (e.g., generate PDF)
            },
            child: Text('Export Report'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
