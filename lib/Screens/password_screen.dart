
import 'package:css_app/Screens/profile_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextfield.dart';
class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;


  bool _validatePassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    return hasUppercase && hasSpecialCharacters && hasMinLength;
  }

  // Method to show spinner and navigate to profile screen if conditions are met
  void _savePassword() {
    if (newPassword.text != confirmPassword.text) {
      _showErrorDialog('Passwords do not match.');
      return;
    }

    if (!_validatePassword(newPassword.text)) {
      _showErrorDialog('Password does not meet the required conditions.');
      return;
    }

    setState(() {
      isLoading = true;

    });

    // Simulate a network call
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Get.off(ProfileScreen());
    });
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
              SizedBox(height: SizeConfig.height(3.0)),
              Center(
                child: Container(
                  width: SizeConfig.width(60),
                  height: SizeConfig.height(30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Password.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height(1.5)),
              Text(
                "Set Password",
                style: TextStyle(
                  color: third,
                  fontSize: 25,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Set your Password",
                  style: TextStyle(
                    color: Color(0xF1F2937).withOpacity(1.0),
                    fontSize: 17,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextField(
                  controller: newPassword,
                  text: "Enter your Password",
                  icon: Icons.person,
                  color: textfield2,
                  clr: textfield2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextField(
                  controller: confirmPassword,
                  text: 'Confirm Password',
                  icon: Icons.lock_open,
                  color: textfield2,
                  clr: textfield2,
                ),
              ),
              SizedBox(height: SizeConfig.height(0.5)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.width(10.0)),
                  passwordCondition('Maximum 8 characters'),
                  SizedBox(width: SizeConfig.width(5)),
                  passwordCondition('At least 1 special character'),
                ],
              ),
              SizedBox(height: SizeConfig.height(1.5)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.width(10.0)),
                  passwordCondition('At least 1 uppercase letter'),
                ],
              ),
              SizedBox(height: SizeConfig.height(2.5)),
              isLoading
                  ? CircularProgressIndicator(color: Colors.yellow)
                  : Myelavatedbutton(
                text: 'Save',
                ontap: _savePassword,
                height: SizeConfig.height(5.5),
                width: SizeConfig.width(80),
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


Widget passwordCondition(String text){
  return   Container(
    width: 131,
    height: 22,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: conditionBox,
    ),
    child: Center(child: Text(text,style: TextStyle(color:condition,fontSize: 10,fontFamily: 'Lato'),)),
  );
}
