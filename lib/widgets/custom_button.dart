import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
