import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/snackbar_utils.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/otp_verify.dart';
import '../../../../../generated/l10n.dart';
import '../../../cubits/register_cubit/register_cubit.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';
import 'gradient_button.dart';
import 'profile_image_uploader.dart';

class RegisterBody extends StatefulWidget {
  final void Function(Locale) setLocale;

  const RegisterBody({super.key, required this.setLocale});

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
      SnackbarUtils.showSnackBar(
        context,
        S.of(context).passwordsDoNotMatch,
        isError: true,
      );
      return;
    }

    if (selectedImage == null) {
      SnackbarUtils.showSnackBar(
        context,
        S.of(context).pleaseSelectProfileImage,
        isError: true,
      );
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
          SnackbarUtils.showSnackBar(
            context,
            S.of(context).registrationSuccess,
          );
          navigateTo(
            OtpVerificationScreen(
              otp: otp,
              email: email,
              setLocale: widget.setLocale,
            ),
            canPop: false,
          );
        } else if (state is RegisterFailure) {
          SnackbarUtils.showSnackBar(context, state.error, isError: true);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: size.height * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                Image.asset(ImageAssets.logo, width: size.width * 0.45),
                SizedBox(height: size.height * 0.06),
                Text(
                  S.of(context).createANewAccount,
                  style: TextStyle(
                      fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                ProfileImageUploader(
                  onImagePicked: (file) => setState(() => selectedImage = file),
                ),
                SizedBox(height: size.height * 0.02),
                CustomTextField(
                  title: S.of(context).userName,
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).userName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: S.of(context).email,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).email;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                      return S.of(context).pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: S.of(context).password,
                  isPasswordField: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).password;
                    }
                    if (value.length < 6) {
                      return S.of(context).passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  title: S.of(context).confirmPassword,
                  isPasswordField: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).confirmPassword;
                    }
                    if (value != passwordController.text) {
                      return S.of(context).passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),
                GradientButton(
                  title: S.of(context).createANewAccount,
                  onPressed: () => _onRegisterPressed(context),
                ),
                SizedBox(height: size.height * 0.01),
                CustomText(
                  onPressed: () => navigateTo(
                    LoginScreen(setLocale: widget.setLocale),
                    canPop: true,
                  ),
                  text2: S.of(context).login,
                  text1: S.of(context).haveAnAccount,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
