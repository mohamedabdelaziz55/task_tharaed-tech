import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import '../widgets/profile_body.dart';

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



