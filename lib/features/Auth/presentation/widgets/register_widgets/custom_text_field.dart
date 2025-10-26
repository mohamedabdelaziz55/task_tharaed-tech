import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    this.controller,
    this.isPasswordField = false, this.validator,
  });
  final String? Function(String?)? validator;

  final String title;
  final TextEditingController? controller;
  final bool isPasswordField;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: size.width * 0.04,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(

          validator: widget.validator,
          controller: widget.controller,
          obscureText: widget.isPasswordField ? obscureText : false,
          keyboardType: widget.isPasswordField
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          decoration: InputDecoration(
            suffixIcon: widget.isPasswordField
                ? GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.remove_red_eye_sharp,
                color: Color(AppColors.primaryColor),
              ),
            )
                : null,
            contentPadding: EdgeInsets.symmetric(
              vertical: size.height * 0.02,
              horizontal: size.width * 0.04,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal.shade400),
            ),
          ),
        ),
      ],
    );
  }
}