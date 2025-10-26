import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/register_screen.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/gradient_button.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text.dart';
import '../../../cubits/login_cubit.dart';
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
            CustomTextField(title: "Email", controller: emailController),
            SizedBox(height: size.height * 0.01),
            CustomTextField(title: "Password", isPasswordField: true, controller: passwordController),
            SizedBox(height: size.height * 0.01),
            const LoginOptionsRow(),
            SizedBox(height: size.height * 0.04),
            GradientButton(
              title: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginCubit>().loginUser(
                    emailController.text,
                    passwordController.text,
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            CustomText(
              text1: "Don't have an account?",
              text2: 'Create a new account',
              onPressed: () => navigateTo(const RegisterScreen(), canPop: false),
            ),
          ],
        ),
      ),
    );
  }
}
