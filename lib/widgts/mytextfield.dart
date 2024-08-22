import 'package:css_app/constants/colors.dart';
import 'package:flutter/material.dart';

import '../constants/height_width.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData? icon;
  final Color color;
  final Color? clr;

  const MyTextField({super.key, required this.controller, required this.text, this.icon,required this.color, this.clr,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: textFieldColor,
      child: Container(
        height: SizeConfig.height(5.5),
        width: SizeConfig.width(78),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:Color(0xFF7BD00).withOpacity(0.2),
        ),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(icon, size: 18,color: clr),
              ),
            Expanded(
              child:Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none
              )
               ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 14,color: color , fontFamily: 'Lato'),
                  contentPadding: EdgeInsets.symmetric(vertical: 3.5,horizontal: 15.0),
                ),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}

