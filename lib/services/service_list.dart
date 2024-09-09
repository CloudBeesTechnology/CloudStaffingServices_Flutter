import 'package:css_app/constants/colors.dart';
import 'package:css_app/services/specific_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ServiceListScreen extends StatelessWidget {
  final String serviceType;

  ServiceListScreen({required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$serviceType List'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dummy users')
            .where('type', isEqualTo: serviceType.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.yellow,));
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No $serviceType found.'));
          } else {
            var users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index].data() as Map<String, dynamic>;
                var userName = user['name'] ?? 'No Name';
                var userCity = user['city'] ?? 'No City';
                var userImageUrl = user['imageUrl'] ?? '';
                var userType = user['type'] ?? 'No Type';
                var userId=user['userId'] ?? '';

                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedProviderDetailsScreen(userId: userId, currentUserId: '',)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Container(
                      width: 270,
                      height: 100,
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        color: conditionBox,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12,),
                          userImageUrl.isNotEmpty
                              ? ClipOval(
                              child: Image.network(userImageUrl, width: 50, height: 50, fit: BoxFit.cover))
                              : Icon(Icons.account_circle_outlined, size: 50),
                          SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8,),
                                Text(
                                  userName,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userCity,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userType,
                                  style: TextStyle(fontSize: 14, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}



