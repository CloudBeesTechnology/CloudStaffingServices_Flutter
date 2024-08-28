
import 'package:css_app/constants/colors.dart';
import 'package:css_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextbuttom.dart';
import '../widgts/mytextfield.dart';
import 'otp_screen.dart';
import 'password_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final Logger _logger = Logger();


  bool isChecked = false;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthService authService=AuthService();
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

  void _register() async {
    if (!isChecked) {
      _showErrorDialog("Please agree to the Terms of Use and Privacy Policy.");
      return;
    }

    if (email.text.isEmpty || password.text.isEmpty || name.text.isEmpty) {
      _showErrorDialog("All fields are required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential? userCredential;

      if (email.text.contains('@')) {
        // Email registration
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        _logger.i('Email registration successful: ${userCredential.user?.email}');
        await Future.delayed(Duration(milliseconds: 200));
        Get.to(() => PasswordScreen());
      } else {
        // Phone number registration
        await _auth.verifyPhoneNumber(
          phoneNumber: email.text.trim(),
          verificationCompleted: (PhoneAuthCredential credential) async {
            userCredential = await _auth.signInWithCredential(credential);
            _logger.i('Phone verification completed automatically: ${userCredential?.user?.phoneNumber}');
            setState(() {
              isLoading = false;
            });
            await Future.delayed(Duration(milliseconds: 200));
            Get.to(() => PasswordScreen());
          },
          verificationFailed: (FirebaseAuthException e) {
            _logger.e('Phone verification failed: ${e.message}');
            setState(() {
              isLoading = false;
            });
            _showErrorDialog("Verification failed: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) async {
            _logger.i('OTP code sent to phone number');
            setState(() {
              isLoading = false;
            });
            await Future.delayed(Duration(milliseconds: 200));
            Get.to(() => OtpScreen(verificationId: verificationId));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _logger.w('Auto retrieval timeout');
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('Registration failed: ${e.message}');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Registration failed: ${e.message}");
    } catch (e) {
      _logger.e('Unexpected error: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("An unexpected error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
        name.clear();
        email.clear();
        password.clear();
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
              SizedBox(height: SizeConfig.height(1)),
              Center(
                child: Container(
                  width: SizeConfig.width(75),
                  height: SizeConfig.height(18),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/walkthrough.jpg'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height(1.5)),
              Card(
                elevation: 3,
                shadowColor: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                      width: SizeConfig.width(90),
                      height: SizeConfig.height(53),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                        child: Column(
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(color: primary1, fontSize: 24, fontFamily: 'Lato'),
                            ),
                            Text(
                              'Create your new account',
                              style: TextStyle(color: login, fontSize: 16),
                            ),
                            SizedBox(height: SizeConfig.height(1)),
                            MyTextField(
                              controller: name,
                              text: 'User Name',
                              icon: Icons.person,
                              color: textfield1,
                              clr:textfield1,
                            ),
                            SizedBox(height: SizeConfig.height(1)),
                            MyTextField(
                              controller: email,
                              text: 'Email/Phone no',
                              icon: Icons.email_outlined,
                              color:textfield1,
                              clr: textfield1,
                            ),
                            SizedBox(height: SizeConfig.height(1)),
                            MyTextField(
                              controller: password,
                              text: 'Password',
                              icon: Icons.lock_clock_outlined,
                              color: textfield1,
                              clr: textfield1,
                            ),
                            SizedBox(height: SizeConfig.height(1)),
                            Row(
                              children: <Widget>[
                                SizedBox(width: SizeConfig.width(1.5),),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    "I agree to Terms of use or Privacy Policy",
                                    style: TextStyle(color:primary1,fontSize: 14,fontFamily: 'Lato'),
                                  ),
                                ),
                              ],
                            ),
                            isLoading // Display the spinner if isLoading is true
                                ? CircularProgressIndicator(color: Colors.yellow,):
                            Myelavatedbutton(
                              text: 'Register',
                              height: SizeConfig.height(5.5),
                              width: SizeConfig.width(80),
                              ontap: _register,  // Disable button when loading
                              color: buttons,
                              color2: secondary,
                              fontSize: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
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
                                            color: Colors.transparent, // or primary color if selected
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
                                  text: 'Forget Password ?',
                                  ontap: () {},
                                  size: 12,
                                  color: Color(0xF0094D9).withOpacity(1.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                                 
                    ),
                  ),
             
              ),
              SizedBox(height: SizeConfig.height(1)),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    'or continue with',
                    style: TextStyle(color: primary1, fontSize: 10,fontFamily: 'Lato'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      indent: 5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height(0.5),),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: SizeConfig.width(6)),
                        iconButton(FontAwesomeIcons.facebook, Colors.blue, () {}),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: GestureDetector(
                          onTap: () async {
                          await authService.loginWithGoogle();
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/ggogle icon.png'),
                          ),
                        ),
                      ),
                    ),

                    iconButton(FontAwesomeIcons.apple, Colors.black, () {}),
                    SizedBox(width: SizeConfig.width(6)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconButton(IconData icon, Color color, VoidCallback ontap) {
  return
  Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    child: CircleAvatar(
      radius: 24,

      foregroundColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: ontap,
                color: Colors.white,
                icon: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
            ],
          ),
    ),
  );


}

