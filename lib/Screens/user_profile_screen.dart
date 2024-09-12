import 'package:css_app/Screens/login_screen.dart';
import 'package:css_app/Screens/welcome_screen.dart';
import 'package:css_app/widgts/myelavatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Method to fetch user data from Firestore
  Future<Map<String, dynamic>> _fetchUserData() async {
    var userId = auth.currentUser!.uid;

    // Fetch the user data from 'dummy users' collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('dummy users')
        .doc(userId)
        .get();

    // Fetch the user's email or phone number
    String? emailOrPhone;
    var emailDoc = await FirebaseFirestore.instance
        .collection('email')
        .doc(userId)
        .get();

    if (emailDoc.exists) {
      emailOrPhone = emailDoc.data()?['email'];
    } else {
      var phoneDoc = await FirebaseFirestore.instance
          .collection('phone')
          .doc(userId)
          .get();
      if (phoneDoc.exists) {
        emailOrPhone = phoneDoc.data()?['phoneNumber'];
      }
    }

    // Fetch the user's password
    DocumentSnapshot passwordDoc = await FirebaseFirestore.instance
        .collection('password')
        .doc(userId)
        .get();

    String password = (passwordDoc.data() as Map<String, dynamic>?)?['password'] ?? 'N/A';

    // Combine all user data
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    userData['emailOrPhone'] = emailOrPhone;
    userData['password'] = password;

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
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
          String imageUrl = userData['imageUrl'] ?? '';
          String emailOrPhone = userData['emailOrPhone'] ?? 'N/A';
          String password = userData['password'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 45)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileRow(icon: Icons.person_outline, label: name),
                _buildDivider(),
                _buildProfileRow(icon: Icons.email_outlined, label: emailOrPhone),
                _buildDivider(),
                _buildProfileRow(icon: Icons.verified_user_outlined, label: type),
                _buildDivider(),
                _buildProfileRow(icon: Icons.location_pin, label: city),
                _buildDivider(),
                _buildProfileRow(icon: Icons.lock_clock_outlined, label: password),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Myelavatedbutton(
                        text: 'Edit Profile',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()),
                          ).then((_) {
                            // Refresh the profile screen after returning from edit profile screen
                            setState(() {});
                          });
                        },
                        height: 30,
                        width: 250,
                        color: buttons,
                        color2: secondary,
                        fontSize: 16,
                      ),
                      Myelavatedbutton(
                        text: 'Log out',
                        ontap: () async {
                          Get.dialog(
                            AlertDialog(
                              title: Text('Log out'),
                              content: Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog
                                    Get.back();
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Clear SharedPreferences and log out
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.clear();

                                    // Navigate to the login screen
                                    Get.offAll(() => LoginScreen());
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        height: 30,
                        width: 250,
                        color: login,
                        color2: secondary,
                        fontSize: 16,
                      ),


                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileRow({required IconData icon, required String label}) {
    return Row(
      children: [
        const SizedBox(width: 25),
        Icon(icon, size: 35, color: buttons),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade300);
  }
}




