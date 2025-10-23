import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';

class ProfileImageUploader extends StatelessWidget {
  const ProfileImageUploader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Image',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textDirection: TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: Color(AppColors.primaryColor),
            strokeWidth: 1.2,
            dashPattern: const [6, 4],
            radius: const Radius.circular(8),
          ),
          child: Container(
            width: double.infinity,
            height: 90,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(AppColors.primaryColor),
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  'Allowed files: JPEG, PNG\nMaximum size: 5 MB',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
