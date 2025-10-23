import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});
final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("have an account?"),
        Text(text , style: TextStyle(
            color: Colors.teal.shade700
        ),)
      ],
    );
  }
}