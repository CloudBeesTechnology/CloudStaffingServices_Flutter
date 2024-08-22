import 'package:flutter/material.dart';

class Myelavatedbutton extends StatelessWidget {
  final String text;
  final VoidCallback? ontap; // Nullable VoidCallback
  final double width;
  final double height;
  final Color color;
  final Color color2;
  final double fontSize;

  const Myelavatedbutton({
    super.key,
    required this.text,
    required this.ontap,
    required this.height,
    required this.width,
    required this.color,
    required this.color2,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: height,
      onPressed: ontap ?? () {},
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          color:color2,
          fontSize: fontSize,
          fontFamily: 'Lato'
        ),
      ),
    );
  }
}

