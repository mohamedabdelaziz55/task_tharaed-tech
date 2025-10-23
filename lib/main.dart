import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/helper_methods.dart';

import 'features/Auth/presentation/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PlayfairDisplay",
        scaffoldBackgroundColor: Colors.white
      ),
      home: const RegisterScreen(),
    );
  }
}

