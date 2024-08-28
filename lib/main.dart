
import 'package:css_app/Screens/home_screen.dart';
import 'package:css_app/Screens/login_screen.dart';
import 'package:css_app/Screens/otp_screen.dart';
import 'package:css_app/Screens/password_screen.dart';
import 'package:css_app/Screens/profile_screen.dart';
import 'package:css_app/Screens/signup_screen.dart';
import 'package:css_app/Screens/walkthrough_screen.dart';
import 'package:css_app/Screens/welcome_screen.dart';
import 'package:css_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Screens/splasScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Css project',
      theme: ThemeData(
        // primarySwatch: Colors.white,
      ),

      home: SplashScreen(),
    );
  }
}