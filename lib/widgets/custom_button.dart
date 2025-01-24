import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color borderColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double borderWidth;
  final FontWeight fontWeight;

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(color: borderColor, width: borderWidth),
        padding: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
