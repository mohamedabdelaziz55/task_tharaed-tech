import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/snackbar_utils.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/otp_verify.dart';
import '../../../cubits/register_cubit/register_cubit.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';
import 'gradient_button.dart';
import 'profile_image_uploader.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  File? selectedImage;

  void _onRegisterPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      SnackbarUtils.showSnackBar(context, "Passwords do not match", isError: true);
      return;
    }

    if (selectedImage == null) {
      SnackbarUtils.showSnackBar(context, "Please select a profile image", isError: true);
      return;
    }

    context.read<RegisterCubit>().registerUser(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      image: selectedImage!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
        }

        if (state is RegisterSuccess) {
          final otp = state.response['data']['otp'].toString();
          final email = state.response['data']['email'].toString();
          SnackbarUtils.showSnackBar(context, "Registration successful");
          navigateTo(OtpVerificationScreen(otp: otp, email: email), canPop: false);
        } else if (state is RegisterFailure) {
          SnackbarUtils.showSnackBar(context, state.error, isError: true);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07, vertical: size.height * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
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
                  onImagePicked: (file) => setState(() => selectedImage = file),
                ),
                SizedBox(height: size.height * 0.02),

                // ✅ Add Validators
                CustomTextField(
                  title: 'User Name',
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  title: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  title: 'Password',
                  isPasswordField: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  title: 'Confirm password',
                  isPasswordField: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),

                GradientButton(
                  title: 'Create a new account',
                  onPressed: () => _onRegisterPressed(context),
                ),
                SizedBox(height: size.height * 0.01),

                CustomText(
                  onPressed: () => navigateTo(const LoginScreen(), canPop: true),
                  text2: 'Login',
                  text1: 'have an account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
