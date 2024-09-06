import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvidersScreen extends StatelessWidget {
  final String currentUserId; // Pass the current logged-in user's ID

  FavoriteProvidersScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          } else {
            var favoriteDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: favoriteDocs.length,
              itemBuilder: (context, index) {
                var providerId = favoriteDocs[index]['providerId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('dummy users')
                      .doc(providerId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading...'),
                      );
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return ListTile(
                        title: Text('Provider not found'),
                      );
                    } else {
                      var providerData = snapshot.data!.data() as Map<String, dynamic>;

                      // Display the provider's details
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: providerData['imageUrl'] != null
                              ? NetworkImage(providerData['imageUrl'])
                              : null,
                          child: providerData['imageUrl'] == null
                              ? Icon(Icons.account_circle)
                              : null,
                        ),
                        title: Text(providerData['name'] ?? 'No Name Provided'),
                        subtitle: Text(providerData['city'] ?? 'No City Provided'),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

