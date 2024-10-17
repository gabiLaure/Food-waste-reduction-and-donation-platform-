import 'package:flutter/material.dart';

class RequestManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Management'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Request #5678'),
            subtitle: Text('Orphanage: Orphanage A\nStatus: Pending'),
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
            title: Text('Request #5679'),
            subtitle: Text('Orphanage: Orphanage B\nStatus: Approved'),
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
          // More request entries
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new request action
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
