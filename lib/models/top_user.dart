import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopUsersCarousel extends StatelessWidget {
  //  TopUsersCarousel({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchTopUsersWithDetails() async {
    List<Map<String, dynamic>> qualifiedUsers = [];
    try {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountType', whereIn: ['Restaurant', 'Supermarket']).get();

      for (var userDoc in usersSnapshot.docs) {
        var userId = userDoc['userUid'];
        var accountType = userDoc['accountType'];

        // Compter les donations acceptées
        QuerySnapshot donationSnapshot = await FirebaseFirestore.instance
            .collection('donations')
            .where('userInfos.userUid', isEqualTo: userId)
            .where('donationStatus', isEqualTo: 'Accepted')
            .where('updatedAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
            .where('updatedAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
            .get();

        // Compter les demandes acceptées
        QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('userInfos.userUid', isEqualTo: userId)
            .where('requestStatus', isEqualTo: 'Accepted')
            .where('updatedAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
            .where('updatedAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
            .get();

        int totalAccepted = donationSnapshot.docs.length +
            requestSnapshot.docs.length; // Total acceptations cette semaine

        if (totalAccepted >= 5) {
          Map<String, dynamic>? linkedDetails = await fetchLinkedDetails(
            accountType,
            userId,
          );

          qualifiedUsers.add({
            'userId': userId,
            'data': userDoc.data(),
            'totalAccepted': totalAccepted,
            'linkedDetails': linkedDetails,
          });
        }
      }

      // Si aucun utilisateur ne se qualifie, récupérer les utilisateurs récents
      if (qualifiedUsers.isEmpty) {
        QuerySnapshot recentUsersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('accountType', whereIn: ['Restaurant', 'Supermarket'])
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

        for (var user in recentUsersSnapshot.docs) {
          Map<String, dynamic>? linkedDetails = await fetchLinkedDetails(
            user['accountType'],
            user['userUid'],
          );

          qualifiedUsers.add({
            'userId': user['userUid'],
            'data': user.data(),
            'totalAccepted': 0,
            'linkedDetails': linkedDetails,
          });
        }
      }

      print('users top');
      print(qualifiedUsers);
    } catch (e) {
      print("Erreur : $e");
    }

    return qualifiedUsers;
  }

  Future<Map<String, dynamic>?> fetchLinkedDetails(
      String accountType, String userId) async {
    try {
      String collectionName =
          accountType == 'Restaurant' ? 'restaurants' : 'supermarkets';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('userProfileID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération des détails liés : $e");
      return null;
    }
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: mediaItems.map((item) {
        if (item['type'] == 'image') {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(item['path']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else if (item['type'] == 'video') {
          int index = mediaItems.indexOf(item) - 2;

          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  final List<Map<String, String>> mediaItems = [
    {'type': 'image', 'path': 'assets/images/orphanage1.jpeg'},
    {'type': 'image', 'path': 'assets/restaurant/restaurantB.jpeg'},
    {'type': 'image', 'path': 'assets/grocery/supermarket3.jpeg'},
  ];
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTopUsersWithDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildCarousel(); // Carrousel par défaut
        }

        List<Map<String, dynamic>> qualifiedUsers = snapshot.data!;

        return CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 3),
          ),
          items: qualifiedUsers.map((user) {
            final imageUrl = user['linkedDetails']?['image'] ??
                'assets/images/placeholder.png';

            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl)
                          : AssetImage(imageUrl) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
