import 'package:css_app/Screens/password_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextbuttom.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();
  bool isLoading = false;

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

  Future<void> _verifyOtp() async {
    setState(() {
      isLoading = true; // Show spinner when verification starts
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _logger.i('OTP verification successful. User: ${userCredential.user?.phoneNumber}');
      Get.to(() => PasswordScreen());
    } on FirebaseAuthException catch (e) {
      _logger.e('OTP verification failed: ${e.message}');
      _showErrorDialog("Invalid OTP: ${e.message}");
    } catch (e) {
      _logger.e('Unexpected error: $e');
      _showErrorDialog("An unexpected error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
        otpController.clear();
        // Hide spinner after verification completes
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _auth.currentUser?.phoneNumber ?? '',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('OTP resend failed: ${e.message}');
          _showErrorDialog("Failed to resend OTP: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId;
          _logger.i('OTP resent successfully.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      _logger.e('Unexpected error during OTP resend: $e');
      _showErrorDialog("An unexpected error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
        otpController.clear();

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
              SizedBox(height: SizeConfig.height(2)),
              Center(
                child: Container(
                  width: SizeConfig.width(60),
                  height: SizeConfig.height(30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image23.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height(2.0)),
              Text(
                "Phone Verification",
                style: TextStyle(
                  color: primary2,
                  fontSize: 25,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.height(1.0),),
              Text(
                "Enter your OTP code",
                style: TextStyle(color: primary1, fontSize: 17),
              ),
              SizedBox(height: SizeConfig.height(1.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: PinCodeTextField(
                  controller: otpController,
                  appContext: context,
                  length: 6,
                  onChanged: (value) {},
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: SizeConfig.height(5.2),
                    fieldWidth: SizeConfig.width(10.4),
                    // Set fill color
                    activeFillColor: textFieldColor.withOpacity(0.2),
                    selectedFillColor: textFieldColor.withOpacity(0.2),
                    inactiveFillColor: textFieldColor.withOpacity(0.2),
                    // Set border color
                    borderWidth: 1,
                    activeColor: textFieldColor.withOpacity(0.1),
                    selectedColor: textFieldColor.withOpacity(0.1),
                    inactiveColor: textFieldColor.withOpacity(0.1),
                  ),
                  cursorColor: Colors.black,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true, // Enable fill
                ),
              ),
              SizedBox(height: SizeConfig.height(2.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive code?',
                    style: TextStyle(
                      color: Color(0xF9CA3AF).withOpacity(1.0),
                      fontSize: 14,
                      fontFamily: 'Lato',
                    ),
                  ),
                  Mytextbuttom(
                    text: 'Resend again',
                    ontap: _resendOtp,
                    color: Color(0xFEAB571).withOpacity(1.0),
                    size: 14,
                  ),
                ],
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.yellow,)
                  : Myelavatedbutton(
                text: 'Verify',
                ontap: _verifyOtp,
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


