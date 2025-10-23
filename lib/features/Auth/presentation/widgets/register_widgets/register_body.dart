import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // لتجنب الـ overflow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset(ImageAssets.logo),
          const SizedBox(height: 20),
          const Text(
            "إنشاء حساب جديد",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 30),
          const ProfileImageUploader(),
        ],
      ),
    );
  }
}

class ProfileImageUploader extends StatelessWidget {
  const ProfileImageUploader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الصورة الشخصية',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 8),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: Colors.teal.shade300,
            strokeWidth: 1.2,
            dashPattern: const [6, 4],
            radius: const Radius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            height: 90,
            color:  Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.teal,
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  'الملفات المسموح بها: JPEG, PNG\nالحد الأقصى: 5 ميغابايت',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
