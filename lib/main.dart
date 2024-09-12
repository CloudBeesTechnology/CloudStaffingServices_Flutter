import 'package:css_app/Screens/home_screen.dart';
import 'package:css_app/Screens/navigation_screen.dart';
import 'package:css_app/Screens/welcome_screen.dart';
import 'package:css_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Screens/login_screen.dart';
import 'Screens/splasScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  // FacebookAuth.instance.webAndDesktopInitialize(
  //   appId: '3743042865950757',
  //   cookie: true,
  //   xfbml: true,
  //   version: 'v13.0',
  // );

  // FirebaseAuth auth = FirebaseAuth.instance;
  // Widget initialScreen;

 // Check if the user is logged in or not
 //  if (auth.currentUser != null) {
 //    SplashScree() = NavigationScreen(); // If logged in, show home screen
 //  } else {
 //    WelcomeScreen() = LoginScreen(); // If not logged in, show login screen
 //  }

  // https://cloudstaffingservices-73a3c.firebaseapp.com/__/auth/handler
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Css project',
      theme: ThemeData(
        // primarySwatch: Colors.white,
      ),

      home: WelcomeScreen(),
    );
  }
}