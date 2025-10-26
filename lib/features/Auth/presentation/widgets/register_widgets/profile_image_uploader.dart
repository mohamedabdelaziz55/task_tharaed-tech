import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/core/widgets/image_picker_dialog.dart';

import '../../../../../generated/l10n.dart';

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
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
      widget.onImagePicked(imageFile!);
    }
    Navigator.pop(context);
  }

  Future<void> pickFromCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
      widget.onImagePicked(imageFile!);
    }
    Navigator.pop(context);
  }

  void _removeImage() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty;

    final String? imageUrl =
        imageFile?.path ?? (hasNetworkImage ? widget.initialImageUrl : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
           S.of(context).profileImage,
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
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null
                        ? (imageFile != null
                        ? Image.file(
                      imageFile!,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          _placeholder(),
                    ))
                        : _placeholder(),
                  ),

                  if (imageUrl != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: _removeImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            color: Color(AppColors.primaryColor),
            size: 32,
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }
}
