import 'package:flutter/material.dart';

class RestaurantManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Management'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Restaurant 1'),
            subtitle: Text('Location: City A'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
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
            title: Text('Restaurant 2'),
            subtitle: Text('Location: City B'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
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
          // Add more restaurants here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add restaurant action
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
