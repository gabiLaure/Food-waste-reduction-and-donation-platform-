import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Users...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle search functionality
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildUserTile('John Doe', 'Donor', true),
                  _buildUserTile('Orphanage A', 'Orphanage', true),
                  _buildUserTile('Grocery Store B', 'Grocery', false),
                  // More user entries
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new user
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[200],
      ),
    );
  }

  Widget _buildUserTile(String name, String role, bool isActive) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(name),
        subtitle: Text(role),
        trailing: Switch(
          value: isActive,
          onChanged: (value) {
            // Handle activation/deactivation
          },
        ),
        onTap: () {
          // Handle user details view or editing
        },
      ),
    );
  }
}
