import 'package:css_app/constants/colors.dart';
import 'package:css_app/widgts/myelavatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedProviderDetailsScreen extends StatelessWidget {
  final String userId;

  SelectedProviderDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Details'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('dummy users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found.'));
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var userName = userData['name'] ?? 'No Name Provided';
            var userCity = userData['city'] ?? 'No City Provided';
            var userImageUrl = userData['imageUrl'] ?? '';
            var userType = userData['type'] ?? 'No Type Provided';
            var userState = userData['state'] ?? 'No State Provided';
            var userDistrict = userData['district'] ?? 'No District Provided';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Image Container
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image: userImageUrl.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(userImageUrl),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: userImageUrl.isEmpty
                          ? Icon(Icons.account_circle, size: 100, color: Colors.grey[400])
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  // User Details Container
                  Card(
                    elevation: 2,
                    shadowColor: textFieldColor,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          // Name
                          Row(
                            children: [
                              Text(
                                'Name: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'City: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userCity,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // State
                          Row(
                            children: [
                              Text(
                                'State: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userState,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 60,),
                              Myelavatedbutton(
                                  text: 'Book',
                                  ontap: (){},
                                  height: 30,
                                  width: 70,
                                  color: buttons,
                                  color2: secondary,
                                  fontSize: 16)
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'District: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userDistrict,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Servicetype: ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userType,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}



