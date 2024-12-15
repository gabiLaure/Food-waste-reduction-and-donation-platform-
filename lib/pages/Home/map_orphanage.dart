import 'package:caritas/map/custom_map.dart';
import 'package:caritas/map/display_map.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importez votre composant CustomMap ici

class OrphanageMapScreen extends StatelessWidget {
  final String orphanageId = 'all-community'; // Filtre par Orphanage ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanages Map'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orphanages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Parse donations from Firestore
          List<Map<String, dynamic>> orphanages =
              snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id,
              'name': doc['orphanageName'],
              'address': doc['address'],
              'imageUrl': doc['imageUrl'],
              'latitude': doc['latitude'],
              'longitude': doc['longitude'],
              'description': doc['description'],
              'email': doc['email'],
              'phone': doc['phone'],
              'healthcare': doc['healthcare'],
              'education': doc['education'],
            };
          }).toList();

          return DisplayMap(orphanages: orphanages);
        },
      ),
    );
  }
}
