import 'package:css_app/Screens/favourite_screen.dart';
import 'package:css_app/Screens/history_screen.dart';
import 'package:css_app/Screens/home_screen.dart';
import 'package:css_app/Screens/user_profile_screen.dart';
import 'package:css_app/provider/bottom_navigation_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/height_width.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  late List<Widget> screens;
  int currentIndex = 0;  // Keep track of the current index

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(),
      FavoriteProvidersScreen(currentUserId: currentUserId!), // Pass the current user ID
      HistoryScreen(),
      UserProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],  // Show the screen based on the currentIndex
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: Colors.yellow.shade700,
        height: SizeConfig.height(6.5),
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            currentIndex = index;  // Update the current index on tap
          });
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/home icon.png', width: 25, height: 25),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/call icon.png', width: 25, height: 25),
              Text('Favourite', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loc icon.png', width: 25, height: 25),
              Text('Location', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_alt_rounded, color: Colors.white),
              Text('Save', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

