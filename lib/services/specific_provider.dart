import 'dart:developer';

import 'package:css_app/constants/colors.dart';
import 'package:css_app/widgts/myelavatedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedProviderDetailsScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  SelectedProviderDetailsScreen({required this.userId, required this.currentUserId });

  @override
  State<SelectedProviderDetailsScreen> createState() => _SelectedProviderDetailsScreenState();
}

class _SelectedProviderDetailsScreenState extends State<SelectedProviderDetailsScreen> {
  bool _isFavorite = false;
  bool isBooked=false;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String number = '+916374195877';  // Placeholder phone number, replace with actual

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _checkIfBooked();
  }

  Future<void> _checkIfBooked() async {
    if (currentUserId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('bookings')  // Change 'favorites' to 'bookings'
        .doc(widget.userId)
        .get();

    setState(() {
      isBooked = doc.exists;  // Check if the provider is already booked
    });
  }

  Future<void> _toggleBooking() async {
    if (currentUserId == null) return;

    if (isBooked) {
      Get.dialog(
        AlertDialog(
          title: Text('Already Booked'),
          content: Text('This provider is already booked.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // If not booked, add to bookings in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('bookings')  // Store booking details in 'bookings'
        .doc(widget.userId)
        .set({
      'providerId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      isBooked = true;
    });

    Get.dialog(
      AlertDialog(
        title: Text('Booking Confirmed'),
        content: Text('The provider has been booked successfully!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkIfFavorite() async {
    if (currentUserId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .doc(widget.userId)
        .get();

    setState(() {
      _isFavorite = doc.exists;
    });
  }

  Future<void> _toggleFavorite() async {
    if (currentUserId == null) return;

    if (_isFavorite) {
      Get.dialog(
        AlertDialog(
          title: Text('Already Added'),
          content: Text('This provider is already in your favorites list.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .doc(widget.userId)
        .set({
      'providerId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isFavorite = true;
    });

    Get.dialog(
      AlertDialog(
        title: Text('Added to Favorites'),
        content: Text('The provider has been added to your favorites list.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  requestCallPermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }
  }

  callNumber() async {
    await requestCallPermission();
    final Uri dialNumber = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(dialNumber)) {
        await launchUrl(dialNumber, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $dialNumber';
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  directCall() async {
    await requestCallPermission();
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res == null || !res) {
      print('Failed to make the call');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Details'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('dummy users').doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.yellow,));
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
                    shadowColor: Colors.grey,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
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
                              Spacer(),
                              IconButton(
                                onPressed: _toggleFavorite,
                                icon: FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 35,
                                  color: _isFavorite ? Colors.orange : Colors.black,
                                ),
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
                              Spacer(),
                              Myelavatedbutton(
                                text: 'Book',
                                ontap: _toggleBooking,
                                height: 30,
                                width: 70,
                                color: isBooked? Colors.grey:buttons,
                                color2: Colors.white,
                                fontSize: 16,
                              ),
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
                  SizedBox(height: 15),
                  // Call Provider
                  Card(
                    shadowColor: Colors.grey,
                    child: Container(
                      width: 320,
                      height: 80,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.phone, size: 30, color: Colors.blue),
                          Text(number, style: TextStyle(color: Colors.black, fontSize: 16)),
                          Myelavatedbutton(
                            text: 'Call',
                            ontap: () async {
                              await callNumber();
                            },
                            height: 30,
                            width: 65,
                            color: buttons,
                            color2: Colors.white,
                            fontSize: 16,
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



