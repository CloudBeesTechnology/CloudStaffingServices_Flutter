import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:css_app/Screens/password_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextbuttom.dart';
import '../widgts/mytextfield.dart';
import 'home_screen.dart';
import 'navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password1 = TextEditingController();
  bool isLoading = false;


  void _login() async {
    if (username.text.isEmpty || password1.text.isEmpty) {
      _showErrorDialog("Both username and password are required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
          .collection('dummy users')
          .where('name', isEqualTo: username.text.trim())
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        var userData = usernameSnapshot.docs.first;

        Map<String, dynamic>? userMap = userData.data() as Map<String, dynamic>?;
        if (userMap != null && userMap.containsKey('userId')) {
          String userId = userMap['userId'];

          DocumentSnapshot passwordDoc = await FirebaseFirestore.instance
              .collection('password')
              .doc(userId)
              .get();

          Map<String, dynamic>? passwordMap = passwordDoc.data() as Map<String, dynamic>?;
          if (passwordMap != null && passwordMap.containsKey('password')) {
            String storedPassword = passwordMap['password'];
            if (storedPassword == password1.text.trim()) {
              // Save username and password in SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('username', username.text.trim());
              await prefs.setString('password', password1.text.trim());

              // Navigate to the next screen
              Get.off(() => NavigationScreen());
            } else {
              _showErrorDialog("Incorrect password.");
            }
          } else {
            _showErrorDialog("No password found for this user.");
          }
        } else {
          _showErrorDialog("User data is invalid.");
        }
      } else {
        _showErrorDialog("Username not found.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      // Automatically log the user in and navigate to the NavigationScreen
      Get.off(() => NavigationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfig.height(2.0)),
              Center(
                child: Container(
                  width: SizeConfig.width(60),
                  height: SizeConfig.height(30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/28097896_7400902.png'),
                    ),
                  ),
                ),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: primary1,
                  fontSize: 36,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.height(1.0)),
              Text(
                "Login to your account",
                style: TextStyle(
                  color: login,
                  fontSize: 18,
                  fontFamily: 'Lato',
                ),
              ),
              SizedBox(height: SizeConfig.height(3.0)),
              MyTextField(
                controller: username,
                text: 'User Name',
                icon: Icons.person,
                color: Colors.black,
                clr: Colors.black,
              ),
              SizedBox(height: SizeConfig.height(1.5)),
              MyTextField(
                controller: password1,
                text: 'Password',
                icon: Icons.lock_open,
                color: Colors.black,
                clr: Colors.black,
                // obscureText: true, // Add this to obscure the password
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      SizedBox(width: SizeConfig.width(2.3),),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xF454545).withOpacity(1.0),
                            width: 1.4,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Mytextbuttom(
                        text: 'Remember me',
                        ontap: () {},
                        size: 12,
                        color: Color(0xFC2C2C2).withOpacity(1.0),
                      ),
                    ],
                  ),
                  Mytextbuttom(
                    text: 'Forget Password?',
                    ontap: () {},
                    size: 12,
                    color: Color(0xF0094D9).withOpacity(1.0),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height(2.0)),
              isLoading
                  ? CircularProgressIndicator(color: Colors.yellow)
                  : Myelavatedbutton(
                text: 'Login',
                height: SizeConfig.height(5.5),
                width: SizeConfig.width(80),
                ontap: _login,
                color: buttons,
                color2: secondary,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



