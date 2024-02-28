import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? icon;
  final String? label;
  final Color? backgroundColor;

  const CustomButton({super.key, 
    required this.onPressed,
     this.icon,
     this.label,
     this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor??buttonColor, // Set the background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the border radius
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon??"assets/icons/right.png",width: defaultIconsSize,height: defaultIconsSize,),
          SizedBox(width: label!=null?8:0),
          Text(label??""),
        ],
      ),
    );
  }
}