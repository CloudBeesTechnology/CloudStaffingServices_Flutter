
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:css_app/Screens/navigation_screen.dart';
import 'package:css_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../constants/height_width.dart';
import '../widgts/myelavatedbutton.dart';
import '../widgts/mytextfield.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController yourName = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController district = TextEditingController();

  File? _image;
  bool isloading=false;

  Future<void> _pickImage() async {
    ImagePicker imagePicker=ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> setUserData() async {
    Get.dialog(
      Center(child: CircularProgressIndicator(color: Colors.yellow)),
      barrierDismissible: false,
    );

    try {
      if (yourName.text.isNotEmpty &&
          service.text.isNotEmpty &&
          city.text.isNotEmpty &&
          state.text.isNotEmpty &&
          district.text.isNotEmpty) {

        FirebaseAuth auth = FirebaseAuth.instance;
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String? imageUrl;

        if (_image != null) {
          try {
            // Ensure the reference path is correct
            String fileName = '${auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
            Reference storageRef = FirebaseStorage.instance.ref().child('user_images').child(fileName);
            UploadTask uploadTask = storageRef.putFile(_image!);

            await uploadTask.whenComplete(() async {
              imageUrl = await storageRef.getDownloadURL();
              log('Image uploaded successfully: $imageUrl');
            }).catchError((error) {
              log('Error uploading image: $error');
              throw error;
            });
          } catch (e) {
            Get.back();
            Get.dialog(
              AlertDialog(
                title: Text('Error'),
                content: Text('Failed to upload image: $e'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok'),
                  ),
                ],
              ),
            );
            return;
          }
        }

        // Store user data including imageUrl (if any) in Firestore
        await firestore.collection('dummy users').doc(auth.currentUser!.uid).set({
          'name': yourName.text.trim(),
          'type': service.text.trim(),
          'city': city.text.trim(),
          'state': state.text.trim(),
          'district': district.text.trim(),
          'userId': auth.currentUser!.uid,
          'imageUrl': imageUrl,
        }).then((value) {
          setState(() {
            yourName.clear();
            service.clear();
            city.clear();
            state.clear();
            district.clear();
            _image = null;
          });
          Get.back();

          Get.dialog(
            AlertDialog(
              title: Text('Success'),
              content: Text('Profile added successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.off(NavigationScreen());
                  },
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        }).catchError((error) {
          log('Error storing user data: $error');
          Get.back();
          Get.dialog(
            AlertDialog(
              title: Text('Error'),
              content: Text('Failed to store user data: $error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        });
      } else {
        Get.back();
        Get.dialog(
          AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all the fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.back();
      Get.dialog(
        AlertDialog(
          title: Text('Error'),
          content: Text('$e'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(height: SizeConfig.height(2.0),),
                Center(
                  child: Text(
                    'Set Profile',
                    style: TextStyle(color: third, fontSize: 25, fontFamily: 'Lato',fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: SizeConfig.height(1.5),),
              Stack(
                children: [
                  Container(
                    width: SizeConfig.width(37),
                    height: SizeConfig.height(18.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFE9E7E7).withOpacity(1.0),
                      image: _image != null
                          ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _image == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xF969393).withOpacity(1.0),
                          size: 90,
                        ),
                      ],
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: SizeConfig.width(10),
                        height: SizeConfig.height(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: buttons,
                          border: Border.all(color:buttons ,width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(0xFFFFBFB).withOpacity(1.0),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height(2.5),),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MyTextField(controller: yourName, text: 'Enter Your Name', color: textfield2,),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MyTextField(controller: service, text: ' Select Service', color: textfield2,)
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MyTextField(controller: city, text: 'City', color: textfield2,),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MyTextField(controller: state, text: 'State', color:textfield2,),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MyTextField(controller: district, text: 'District', color: textfield2,),
              ),
              SizedBox(height: SizeConfig.height(3.0),),
                Myelavatedbutton(text: 'Continue',
                  ontap: () async{
                      await setUserData();
                },
                  height: SizeConfig.height(5.5),
                  width: SizeConfig.width(80),
                  color: buttons,
                  color2: secondary,
                  fontSize: 16,)

            ],
          ),
        ),
      ),
    );
  }
}

