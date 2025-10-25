import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import '../../../Auth/presentation/widgets/register_widgets/gradient_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(AppColors.gradientColor1),
              Color(AppColors.gradientColor2),
            ],
            center: Alignment.topLeft,
            radius: 1.2,
          ),
        ),
        child: const SafeArea(child: ProfileBody()),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: h * 0.015),

        ProfileImageUploader(
          onImagePicked: (file) {
            setState(() {
              profileImage = file;
            });
            // تقدر هنا تستخدم AuthRepo لرفع الصورة للباك
          },
        ),

        SizedBox(height: h * 0.03),

        const CustomTextField(title: "User Name"),
        SizedBox(height: h * 0.015),
        const CustomTextField(title: "Email"),
        SizedBox(height: h * 0.015),
        const CustomTextField(title: "Old Password", isPasswordField: true),
        SizedBox(height: h * 0.015),
        const CustomTextField(title: "New Password", isPasswordField: true),
        SizedBox(height: h * 0.015),
        const CustomTextField(title: "Confirm New Password", isPasswordField: true),

        SizedBox(height: h * 0.03),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.15),
          child: GradientButton(
            title: 'Update Profile',
            onPressed: () {
              if (profileImage != null) {
                print("Image ready to upload: ${profileImage!.path}");
              }
            },
          ),
        ),
      ],
    );
  }
}
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
