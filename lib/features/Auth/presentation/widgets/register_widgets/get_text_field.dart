import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class GetTextField extends StatelessWidget {
  const GetTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [   const CustomTextField(
        title: 'User Name',
        isPasswordField: false,
      ),
        SizedBox(height: 12),

        const CustomTextField(
          title: 'Email',
          isPasswordField: false,
        ),
        SizedBox(height: 12),

        const CustomTextField(
          title: 'Password',
          isPasswordField: true,
        ),
        SizedBox(height: 12),

        const CustomTextField(
          title: 'Confirm password',
          isPasswordField: true,
        ),],
    );
  }
}
