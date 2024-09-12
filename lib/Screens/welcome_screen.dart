
import 'package:css_app/Screens/signup_screen.dart';
import 'package:css_app/Screens/welcome_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import 'login_screen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
           Center(
             child: Container(
              width:SizeConfig.width(75) ,
              height: SizeConfig.height(40),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/main.png'),
                )
              ),
              child: Column(

              ),
                       ),
           ),

        SizedBox(height: SizeConfig.height(8),),
       Myelavatedbutton(text: 'Sign In',
         height: SizeConfig.height(5.5),
         width: SizeConfig.width(80),
           ontap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
       },
         color: buttons,
         color2: secondary,
         fontSize: 16,
       ),
         SizedBox(height: SizeConfig.height(2),),
       Myelavatedbutton(text: 'Create an Account',
         ontap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
       },
         height: SizeConfig.height(5.5),
         width: SizeConfig.width(80),
         color: Color(0xF9CA3AF).withOpacity(1.0),
         color2: secondary,
         fontSize: 16,
       ),
      ],
    ),
    );
  }
}
