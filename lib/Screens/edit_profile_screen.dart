import 'package:css_app/Screens/user_profile_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:css_app/widgts/myelavatedbutton.dart';
import 'package:css_app/widgts/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TextEditingControllers for fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); // Only one password field

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

// Helper function to show an AlertDialog
  Future<void> _showAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Method to load user data
  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print('User ID: ${user.uid}'); // Log the user ID to check authentication
        DocumentSnapshot userData = await _firestore.collection('dummy users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            nameController.text = userData['name'] ?? '';
            emailController.text = user.email ?? ''; // Using Firebase email
            serviceController.text = userData['type'] ?? '';
            cityController.text = userData['city'] ?? '';
          });
        } else {
          print('No user data found');
          await _showAlertDialog('Error', 'No user data found in Firestore.');
        }
      } else {
        print('User not signed in');
        await _showAlertDialog('Error', 'User not signed in.');
      }
    } catch (e) {
      print('Error loading user data: $e');
      await _showAlertDialog('Error', 'Failed to load user data: $e');
    }
  }

// Method to update the user profile and authentication details
  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update Firestore with the new data
        await _firestore.collection('dummy users').doc(user.uid).update({
          'name': nameController.text.trim(),
          'type': serviceController.text.trim(),
          'city': cityController.text.trim(),
        });

        // Update email if it has been changed
        if (emailController.text.isNotEmpty && emailController.text.trim() != user.email) {
          await user.updateEmail(emailController.text.trim());
          await _firestore.collection('email').doc(user.uid).update({
            'email': emailController.text.trim(),
          });
        }

        // Update password if provided
        if (passwordController.text.isNotEmpty) {
          await user.updatePassword(passwordController.text.trim());
          await _firestore.collection('password').doc(user.uid).update({
            'password': passwordController.text.trim(),
          });
        }

        await _showAlertDialog('Success', 'Profile updated successfully!');
        Navigator.of(context).pop(); // Navigate back to the profile screen
      }
    } catch (e) {
      await _showAlertDialog('Error', 'Failed to update profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow,))
          : Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60,),
                  MyTextField(controller: nameController, text: 'Name', color: textfield1),
                  SizedBox(height: 15,),
                  MyTextField(controller: emailController, text: 'Email or Phone No', color: textfield1),
                  SizedBox(height: 15,),
                  MyTextField(controller: serviceController, text: 'service type', color: textfield1),
                  SizedBox(height: 15,),
                  MyTextField(controller: cityController, text: 'City', color: textfield1),
                  SizedBox(height: 15,),
                  MyTextField(controller: passwordController, text: 'Password', color: textfield1),
                  const SizedBox(height: 30),
                  Myelavatedbutton(
                      text: "Save Changes",
                      ontap: _updateProfile,
                      height: 35,
                      width: 220,
                      color: buttons,
                      color2: secondary,
                      fontSize: 16)
                ],
              ),
            ),
          ),
    );
  }
}












