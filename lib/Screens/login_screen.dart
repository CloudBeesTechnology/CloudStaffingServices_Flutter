import 'package:css_app/Screens/password_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextbuttom.dart';
import '../widgts/mytextfield.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password1 = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password1.text.trim(),
      );

      // If successful, navigate to the home screen
      Get.to(() => PasswordScreen());
    } on FirebaseAuthException catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text('Login Failed'),
          content: Text(e.message ?? 'An error occurred during login.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
        username.clear();
        password1.clear();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary1),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  ? CircularProgressIndicator(color: Colors.yellow,)
             : Myelavatedbutton(
                text:   'Login',
                height: SizeConfig.height(5.5),
                width: SizeConfig.width(80),
                ontap:  _login,  // Disable button if loading
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


