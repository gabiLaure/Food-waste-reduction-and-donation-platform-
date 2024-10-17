import 'package:flutter/material.dart';

class DonationManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Management'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Donation #1234'),
            subtitle: Text('Donor: Restaurant A\nStatus: Pending'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit status action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete action
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Donation #1235'),
            subtitle: Text('Donor: Grocery B\nStatus: In Progress'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit status action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete action
                  },
                ),
              ],
            ),
          ),
          // More donation entries
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new donation action
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
