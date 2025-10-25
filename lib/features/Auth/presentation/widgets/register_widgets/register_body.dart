import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/otp_verify.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import '../../../../../core/utils/helpers/helper_methods.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../data/repo/auth_repo.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';
import 'gradient_button.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  File? selectedImage;
  final AuthRepo authRepo = AuthRepo();

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    if (passwordController.text != confirmPasswordController.text) {
      SnackbarUtils.showSnackBar(context, "Passwords do not match", isError: true);
      return;
    }
    if (selectedImage == null) {
      SnackbarUtils.showSnackBar(context, "Please select a profile image", isError: true);
      return;
    }
    final bytes = await selectedImage!.length();
    if (bytes > 5 * 1024 * 1024) {
      SnackbarUtils.showSnackBar(context, "Image must be less than 5MB", isError: true);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await authRepo.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernameController.text.trim(),
        image: selectedImage!,
        passwordConfirmation: confirmPasswordController.text.trim(),
      );

      // اقفل الـ dialog أول ما يخلص التسجيل
      Navigator.pop(context);

      if (response['status'] != null && response['status'] == 'success') {
        SnackbarUtils.showSnackBar(context, response['message'] ?? "Registration successful");

        // جلب OTP و email من response وإرسالهم للـ OTP screen
        final otp = response['data']['otp'].toString();
        final email = response['data']['email'].toString();
        navigateTo(OtpVerificationScreen(otp: otp, email: email), canPop: false);
      } else {
        SnackbarUtils.showSnackBar(context, response['message'] ?? "Registration failed", isError: true);
      }
    } catch (e) {
      Navigator.pop(context); // اقفل الـ dialog لو حصل خطأ
      SnackbarUtils.showSnackBar(context, "Registration failed: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07, vertical: size.height * 0.02),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              Image.asset(ImageAssets.logo, width: size.width * 0.45),
              SizedBox(height: size.height * 0.06),
              Text(
                "Create a new account",
                style: TextStyle(fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              ProfileImageUploader(
                onImagePicked: (file) {
                  setState(() {
                    selectedImage = file;
                  });
                },
              ),
              SizedBox(height: size.height * 0.02),
              CustomTextField(title: 'User Name', isPasswordField: false, controller: usernameController),
              SizedBox(height: 12),
              CustomTextField(title: 'Email', isPasswordField: false, controller: emailController),
              SizedBox(height: 12),
              CustomTextField(title: 'Password', isPasswordField: true, controller: passwordController),
              SizedBox(height: 12),
              CustomTextField(title: 'Confirm password', isPasswordField: true, controller: confirmPasswordController),
              SizedBox(height: size.height * 0.03),
              GradientButton(title: 'Create a new account', onPressed: register),
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
      ),
    );
  }
}
