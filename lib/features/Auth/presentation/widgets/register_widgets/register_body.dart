import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import '../../../../../core/utils/helpers/helper_methods.dart';
import 'custom_text.dart';
import 'get_text_field.dart';
import 'gradient_button.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  File? selectedImage;

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
            SizedBox(height: size.height * 0.06),
            Image.asset(ImageAssets.logo, width: size.width * 0.45),
            SizedBox(height: size.height * 0.06),
            Text(
              "Create a new account",
              style: TextStyle(
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.03),

            ProfileImageUploader(
              onImagePicked: (file) {
                setState(() {
                  selectedImage = file;
                });
                print("Image selected: ${selectedImage!.path}");
              },
            ),
            SizedBox(height: size.height * 0.02),

            GetTextField(),
            SizedBox(height: size.height * 0.03),

            GradientButton(
              title: 'Create a new account',
              onPressed: () {
                if (selectedImage != null) {
                  print("Ready to upload image: ${selectedImage!.path}");
                }
              },
            ),
            SizedBox(height: size.height * 0.01),
            CustomText(
              onPressed: () {
                navigateTo(const LoginScreen(), canPop: true);
              },
              text2: 'Login',
              text1: 'have an account',
            ),
          ],
        ),
      ),
    );
  }
}
