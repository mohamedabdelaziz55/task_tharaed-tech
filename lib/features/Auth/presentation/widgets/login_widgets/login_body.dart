import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/register_screen.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/gradient_button.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/custom_text.dart';
import '../../../../../generated/l10n.dart';
import '../../../cubits/login_cubit/login_cubit.dart';
import 'custom_login_opions_row.dart';

class LoginBody extends StatefulWidget {
  final void Function(Locale) setLocale;

  const LoginBody({super.key, required this.setLocale});

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
            Text(S.of(context).login, style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.w700)),
            SizedBox(height: size.height * 0.045),

            CustomTextField(
              title: S.of(context).email,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).emailCannotBeEmpty;
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return S.of(context).enterValidEmail;
                }
                return null;
              },
            ),

            SizedBox(height: size.height * 0.01),

            CustomTextField(
              title: S.of(context).password,
              isPasswordField: true,
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).passwordCannotBeEmpty;
                }
                if (value.length < 8) {
                  return S.of(context).passwordMinLength;
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
              title: S.of(context).login,
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
              text1: S.of(context).dontHaveAccount,
              text2: S.of(context).createANewAccount,
              onPressed: () => navigateTo(RegisterScreen(setLocale: widget.setLocale), canPop: false),
            ),
          ],
        ),
      ),
    );
  }
}
