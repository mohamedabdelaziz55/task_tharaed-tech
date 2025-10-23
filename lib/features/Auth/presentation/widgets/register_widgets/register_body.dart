import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import 'get_text_field.dart';
import 'gradient_button.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.04),
            Image.asset(ImageAssets.logo, width: size.width * 0.35),
            SizedBox(height: size.height * 0.02),
            Text(
              "Create a new account",
              style: TextStyle(
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            const ProfileImageUploader(),
            SizedBox(height: size.height * 0.02),

            GetTextField(),
            SizedBox(height: size.height * 0.03),

            GradientButton(title: 'Create a new account', onPressed: () {}),
            SizedBox(height: size.height * 0.03),
            CustomText()
          ],
        ),
      ),
    );
  }
}
class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("have an account?"),
        Text(" Login" , style: TextStyle(
          color: Colors.teal.shade700
        ),)
      ],
    );
  }
}
