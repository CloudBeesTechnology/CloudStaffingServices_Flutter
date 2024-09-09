import 'package:css_app/constants/colors.dart';
import 'package:css_app/widgts/myelavatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Method to fetch user data
  Future<Map<String, dynamic>> _fetchUserData() async {
    var userId = auth.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('dummy users')
        .doc(userId)
        .get();

    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(), // Fetch user data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          }

          // Extract user data
          var userData = snapshot.data!;
          String name = userData['name'] ?? 'N/A';
          String type = userData['type'] ?? 'N/A';
          String city = userData['city'] ?? 'N/A';
          String state = userData['state'] ?? 'N/A';
          String district = userData['district'] ?? 'N/A';
          String imageUrl = userData['imageUrl'] ?? '';

          return Column(
            children: [
              SizedBox(height: 15,),
              // Display profile image
              imageUrl.isNotEmpty
                  ? Center(
                    child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                  )
                  : CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 30),

              // Display user details
              Text('Name', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              Text(name, style: TextStyle(fontSize: 15)),
              SizedBox(height: 12),
              Text('Type', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              Text(type, style: TextStyle(fontSize: 15)),
              SizedBox(height: 12,),
              Text('City', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              Text(city, style: TextStyle(fontSize: 15)),
              SizedBox(height: 12,),
              Text('District', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              Text(district, style: TextStyle(fontSize: 15)),
              SizedBox(height: 30,),
              Myelavatedbutton(
                  text: 'Edit',
                  ontap: (){},
                  height: 40,
                  width: 300,
                  color: buttons,
                  color2: Colors.white,
                  fontSize: 18),
              SizedBox(height: 10,),
              Myelavatedbutton(
                  text: 'Log out',
                  ontap: (){},
                  height: 40,
                  width: 300,
                  color: login,
                  color2: Colors.white,
                  fontSize: 16)
            ],
          );
        },
      ),
    );
  }
}

