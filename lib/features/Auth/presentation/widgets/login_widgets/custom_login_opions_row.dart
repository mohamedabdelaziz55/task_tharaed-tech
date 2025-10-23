
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class LoginOptionsRow extends StatefulWidget {
  const LoginOptionsRow({super.key});

  @override
  State<LoginOptionsRow> createState() => _LoginOptionsRowState();
}

class _LoginOptionsRowState extends State<LoginOptionsRow> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: .8,
              child: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
                activeColor: Color(AppColors.primaryColor),
              ),
            ),
            Text(
              "Remember me",
              style: TextStyle(fontSize: size.width * 0.032),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              fontSize: size.width * 0.032,
              color: Color(AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}


