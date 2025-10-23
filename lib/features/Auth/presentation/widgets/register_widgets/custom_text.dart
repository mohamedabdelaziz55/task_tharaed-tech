import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, this.onPressed, required this.text2, required this.text1});
final String text2;
final String text1;
final  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$text1?", style: TextStyle(fontSize: 12),),
        TextButton(
          onPressed:onPressed ,
          child: Text(text2 , style: TextStyle(
              color: Colors.teal.shade700, fontSize: 12,
          ),),
        )
      ],
    );
  }
}