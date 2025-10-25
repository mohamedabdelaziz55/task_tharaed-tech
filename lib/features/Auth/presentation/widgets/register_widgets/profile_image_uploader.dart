import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/core/widgets/image_picker_dialog.dart';

class ProfileImageUploader extends StatefulWidget {
  final void Function(File) onImagePicked;
  final String? initialImageUrl;

  const ProfileImageUploader({
    super.key,
    required this.onImagePicked,
    this.initialImageUrl,
  });

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      widget.onImagePicked(imageFile!);
    }
    Navigator.pop(context);
  }

  Future<void> pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      widget.onImagePicked(imageFile!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty;

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
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ImagePickerDialog(
                onGallery: pickFromGallery,
                onCamera: pickFromCamera,
              ),
            );
          },
          child: DottedBorder(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageFile != null
                    ? Image.file(
                  imageFile!,
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                )
                    : hasNetworkImage
                    ? Image.network(
                  widget.initialImageUrl!,
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => _placeholder(),
                )
                    : _placeholder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Column(
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
        ),
      ],
    );
  }
}
