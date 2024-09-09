import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
class HistoryScreen extends StatefulWidget {
  final String currentUserId; // Pass the current logged-in user's ID

  HistoryScreen({required this.currentUserId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('History'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUserId)
            .collection('bookings')  // Use 'bookings' collection
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No booking history.'));
          } else {
            var bookingDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookingDocs.length,
              itemBuilder: (context, index) {
                var providerId = bookingDocs[index]['providerId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('dummy users')  // Fetch from the actual provider collection
                      .doc(providerId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.yellow,),
                      );
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                      child: Text('No History found'),
                      );
                    } else {
                      var providerData = snapshot.data!.data() as Map<String, dynamic>;
                      var providerName=providerData['name'] ?? 'No name Provided';
                      var city=providerData['city'] ?? 'No City Provided';
                      var type=providerData['type'] ?? 'No type Provided';
                      var imageUrl=providerData['imageUrl'] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Container(
                          height:85 ,
                          width: 270,
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12,),
                        imageUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(imageUrl, width: 50,height: 50,fit: BoxFit.cover,),)
                          : Icon(Icons.account_circle_outlined, size: 50),
                        SizedBox(width: 25,),
                        Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            Text(
                              providerName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              city,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              type,
                              style: TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ],
                        ),
                        ),],
                        ),
                        ),
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

