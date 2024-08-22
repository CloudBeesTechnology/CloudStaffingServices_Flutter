import 'package:flutter/material.dart';
class Mytextbuttom extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback ontap;
  final double size;
  const Mytextbuttom({super.key, required this.text,required this.ontap, required this.color,required this.size});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed:ontap,
        child: Text(text,style: TextStyle(color: color,fontSize: size,fontFamily: 'Lato'),));
  }
}
