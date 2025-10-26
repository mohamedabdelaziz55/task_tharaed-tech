import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/register_screen.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/gradient_button.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text.dart';
import '../../../cubits/login_cubit/login_cubit.dart';
import 'custom_login_opions_row.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "mm@mm.com");
  final passwordController = TextEditingController(text: "12345678");
  bool rememberMe = false;
  @override
  void initState() {
    super.initState();
    _loadCredentialsFromCubit();
  }

  Future<void> _loadCredentialsFromCubit() async {
    final credentials = await context.read<LoginCubit>().loadSavedCredentials();
    setState(() {
      rememberMe = credentials['rememberMe'];
      emailController.text = credentials['email'];
      passwordController.text = credentials['password'];
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: size.height * 0.03),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.06),
            Image.asset(ImageAssets.logo, width: size.width * 0.45),
            SizedBox(height: size.height * 0.06),
            Text("Login", style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.w700)),
            SizedBox(height: size.height * 0.045),

            CustomTextField(
              title: "Email",
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email cannot be empty";
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return "Enter a valid email address";
                }
                return null;
              },
            ),

            SizedBox(height: size.height * 0.01),

            CustomTextField(

              title: "Password",
              isPasswordField: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password cannot be empty";
                }
                if (value.length < 8) {
                  return "Password must be at least 8 characters";
                }
                return null;
              },
            ),

            SizedBox(height: size.height * 0.01),
            LoginOptionsRow(
              rememberMe: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
            ),
            SizedBox(height: size.height * 0.04),
            GradientButton(
              title: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginCubit>().loginUser(
                    emailController.text,
                    passwordController.text,
                    rememberMe: rememberMe,
                  );
                }
              },
            ),

            SizedBox(height: size.height * 0.03),
            CustomText(
              text1: "Don't have an account",
              text2: 'Create a new account',
              onPressed: () => navigateTo(const RegisterScreen(), canPop: false),
            ),
          ],
        ),
      ),
    );
  }
}
