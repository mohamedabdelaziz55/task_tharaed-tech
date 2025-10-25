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

class _ProfileBodyState extends State<ProfileBody> with TickerProviderStateMixin {
  File? profileImage;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // بدء الأنيميشن بعد تحميل الصفحة
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(w * 0.04),
          child: const CustomAppBar(),
        ),
        SizedBox(height: h * 0.015),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * 0.04),
                topRight: Radius.circular(w * 0.04),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.025,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: ProfileImageUploader(
                          onImagePicked: (file) {
                            setState(() {
                              profileImage = file;
                            });
                            print("Image selected: ${file.path}");
                          },
                        ),
                      ),

                      SizedBox(height: h * 0.03),

                      /// الحقول
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
                        child: InkWell(
                          onTap: () {
                            if (profileImage != null) {
                              print("Ready to upload: ${profileImage!.path}");
                            } else {
                              print("No image selected");
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: GradientButton(title: 'Update Profile', onPressed: () {}),
                        ),
                      ),

                      SizedBox(height: h * 0.015),

                      TextButton(
                        onPressed: () {
                          print("Logout pressed");
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.05),
                    ],
                  ),
                ),
              ),
            ),
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
