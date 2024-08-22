import 'package:css_app/Screens/walkthrough_screen.dart';
import 'package:flutter/material.dart';
import '../constants/height_width.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future.delayed(Duration(seconds: 4), () {
       Navigator.pushReplacement(
        context,
         MaterialPageRoute(builder: (context) => WalkthroughScreen()),
       );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/csss logo.png',
          width: 229, // Adjust the size as needed
          height: 170,
        ),
      ),
    );
  }
}