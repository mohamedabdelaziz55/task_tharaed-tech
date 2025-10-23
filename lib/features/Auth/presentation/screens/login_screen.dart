import 'package:flutter/material.dart';

import '../widgets/login_widgets/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LoginBody()),
    );
  }
}
