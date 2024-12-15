import 'package:caritas/models/orphanage.dart';
import 'package:caritas/pages/Orphanage/orphanage_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrphanageListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanages'),
        // backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orphanages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement pendant le fetching
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Affiche un message d'erreur si la récupération échoue
            return Center(child: Text('An error occurred!'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Affiche un message si aucun orphelinat n'est trouvé
            return Center(child: Text('No orphanages found.'));
          }

          // Convertir les documents en objets Orphanage
          final orphanages = snapshot.data!.docs
              .map((doc) => Orphanage.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: orphanages.length,
            itemBuilder: (context, index) {
              final orphanage = orphanages[index];
              return OrphanageCard(orphanage: orphanage);
            },
          );
        },
      ),
    );
  }
}

class OrphanageCard extends StatelessWidget {
  final Orphanage orphanage;

  OrphanageCard({required this.orphanage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrphanageDetailPage(orphanage: orphanage),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                orphanage.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orphanage.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    orphanage.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
