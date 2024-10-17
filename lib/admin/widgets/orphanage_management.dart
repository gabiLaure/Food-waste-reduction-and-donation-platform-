import 'package:flutter/material.dart';

import '../screens/edit_orphanage.dart';

class OrphanageManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Management'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Orphanage 1'),
            subtitle: Text('Location: City A'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditOrphanageRegistration()));
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
            title: Text('Orphanage 2'),
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
          // Add more orphanages here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add orphanage action
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
