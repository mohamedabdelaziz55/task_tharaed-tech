import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';

import '../../generated/l10n.dart';

class ImagePickerDialog extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  const ImagePickerDialog({
    super.key,
    required this.onGallery,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).selectImageSource,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onGallery,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(AppColors.primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.photo_library,
                          color: Color(AppColors.primaryColor),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).gallery,
                        style: TextStyle(
                          color: Color(AppColors.primaryColor),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onCamera,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(AppColors.primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(AppColors.primaryColor),
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).camera,
                        style: TextStyle(
                          color: Color(AppColors.primaryColor),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
