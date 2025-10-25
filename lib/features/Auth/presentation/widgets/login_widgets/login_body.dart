import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/register_screen.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/gradient_button.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import 'custom_login_opions_row.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepo authRepo = AuthRepo();

  Future<void> loginUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final user = await authRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context);

      if (user.token != null && user.token!.isNotEmpty) {
        SnackbarUtils.showSnackBar(context, "Login successful");
        navigateTo(const ProfileScreen(), canPop: false);
      } else {
        SnackbarUtils.showSnackBar(context, "Invalid credentials", isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      SnackbarUtils.showSnackBar(context, "Login failed: $e", isError: true);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: size.height * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              Image.asset(ImageAssets.logo, width: size.width * 0.45),
              SizedBox(height: size.height * 0.06),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: size.height * 0.045),
              CustomTextField(title: "Email", controller: emailController),
              SizedBox(height: size.height * 0.01),
              CustomTextField(
                title: "Password",
                isPasswordField: true,
                controller: passwordController,
              ),
              SizedBox(height: size.height * 0.01),
              const LoginOptionsRow(),
              SizedBox(height: size.height * 0.04),
              GradientButton(
                title: 'Login',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    loginUser();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              CustomText(
                text1: "Don't have an account?",
                text2: 'Create a new account',
                onPressed: () {
                  navigateTo(const RegisterScreen(), canPop: false);
                },
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
