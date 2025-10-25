import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: w * 0.1),
        Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white24,
          radius: w * 0.06,
          child: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: w * 0.055,
          ),
        ),
      ],
    );
  }
}
