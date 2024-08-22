
import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';
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
  TextEditingController yourNmae = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController district = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
                    width: SizeConfig.width(36),
                    height: SizeConfig.height(18),
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
                child: MyTextField(controller: yourNmae, text: 'Enter Your Nmae', color: textfield2,),
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
                  ontap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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

